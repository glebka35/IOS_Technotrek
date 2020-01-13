//
//  Article.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 26/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation
import UIKit

struct ArticleResponse: Decodable {
    let articles: [ArticleDetail]
}

struct ArticleDetail: Decodable {
    var author: String?
    var title: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var source : Source?
    var image: Data?
    var description: String?
}

struct Source: Decodable {
    var id: String?
    var name: String?
}


