//
//  NewsTableViewController.swift
//  Good News
//
//  Created by Oleg Krikun on 23.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    private let disposeBag = DisposeBag()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
    }
    
    private func getNews() {
        URLRequest.load(resource: ArticlesList.all)
            .subscribe { [weak self] result in
                if let self = self,
                   let result = result {
                    self.articles = result.articles
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell doesn't exist!")
        }
        
        let article = articles[indexPath.row]
        cell.setup(article: article)
        return cell
    }
}
