//
//  ArticleViewModel.swift
//  NewsAppMVVM
//
//  Created by Oleg Krikun on 24.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticlesListViewModel {
    let articlesVM: [ArticleViewModel]
}

extension ArticlesListViewModel {
    init(_ articles: [Article]) {
        self.articlesVM = articles.compactMap(ArticleViewModel.init)
    }
}

extension ArticlesListViewModel {
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
}

struct ArticleViewModel {
    let article: Article
    
    init(_ article: Article) {
        self.article = article
    }
}

extension ArticleViewModel {
    var title: Observable<String> {
        return  Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
}
