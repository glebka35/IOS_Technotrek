//
//  ArticleRequest.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 26/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

enum ArticleError:Error {
    case NoDataAvailable
    case canNotProcessData
}

struct ArticleRequest {
    let resourceURL:URL
    let API_KEY = "3261fe0c899147bea616ee4669ef54bf"
    var isDownloadGood = false
    
    init(category:String) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-mm-dd"
        let currentDate = format.string(from: date)
        
        let resourceString = "https://newsapi.org/v2/everything?q=\(category)&from=\(currentDate)&sortBy=publishedAt&apiKey=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getArticles (completion: @escaping(Result<[ArticleDetail], ArticleError>) -> Void) {
        let datatask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.NoDataAvailable))
                return
            }
            do{
                let articlesResponse = try JSONDecoder().decode(ArticleResponse.self, from: jsonData)
                let articleDetails = articlesResponse.articles
                completion(.success(articleDetails))
            }
            catch{
                completion(.failure(.canNotProcessData))
            }
        }
        datatask.resume()
    }
}
