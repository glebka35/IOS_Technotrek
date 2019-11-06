//
//  Article.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 26/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [ArticleDetail]
}

struct ArticleDetail: Decodable {
    let author: String?
    let title: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String
    let source: Source?
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
