//
//  ArticleTableViewCell.swift
//  Good News
//
//  Created by Oleg Krikun on 24.05.2021.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
    }
}
