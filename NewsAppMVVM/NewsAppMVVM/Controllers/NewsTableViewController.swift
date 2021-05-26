//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by Oleg Krikun on 24.05.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class NewsTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private var articleListVM: ArticlesListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
    }
    
    private func getNews() {
        URLRequest.load(resource: ArticlesList.all)
            .observe(on: MainScheduler.instance)
            .subscribe { [unowned self] articleResponse in
                let articles = articleResponse.articles
                self.articleListVM = ArticlesListViewModel(articles)
                self.tableView.reloadData()
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("onCompleted getNews load")
        } onDisposed: {
            print("onDisposed getNews load")
        }.disposed(by: disposeBag)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleListVM == nil ? 0 : articleListVM.articlesVM.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell doesn't exist!")
        }

        let articleVM = articleListVM.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        return cell
    }
}
