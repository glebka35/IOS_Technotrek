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
    
    let API_KEY = "3261fe0c899147bea616ee4669ef54bf"
    
    func getArticles (category:String, page: Int, completion: @escaping(Result<[ArticleDetail], ArticleError>) -> Void) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-mm-dd"
        let currentDate = format.string(from: date)
        
        var urlComponents = URLComponents();
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: category),
            URLQueryItem(name: "from", value: currentDate),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "apiKey", value: API_KEY),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let articlesURL = urlComponents.url else
        {
            print("Error while getting URL\n")
            return
        }
        
        let datatask = URLSession.shared.dataTask(with: articlesURL) {data, _, _ in
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
