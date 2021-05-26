//
//  Article.swift
//  Good News
//
//  Created by Oleg Krikun on 24.05.2021.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
       let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2021-04-25&sortBy=publishedAt&apiKey=90bdfbb7feda414da92cfdf6c8b6e142")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String
    let description: String?
}
