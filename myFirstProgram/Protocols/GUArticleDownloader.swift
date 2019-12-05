//
//  ArticleDownloader.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 05/12/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

enum ArticleError:Error {
    case NoDataAvailable
    case canNotProcessData
}

protocol GUArticleDownloader {
    func makeURL(category:String, page: Int) -> URL?
    func downloadArticles (category:String, page: Int, completion: @escaping(Result<[ArticleDetail], ArticleError>) -> Void)
}
