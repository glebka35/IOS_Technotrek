//
//  ArticleRequest.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 26/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

class GUArticleDownloaderImpl : GUArticleDownloader {
    let API_KEY = "3261fe0c899147bea616ee4669ef54bf"
    let API_KEY2 = "e5ad458bf2844b628f5e593e7edd1e96"
    func makeURL(category:String, page: Int) -> URL?{
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
            URLQueryItem(name: "apiKey", value: API_KEY2),
            URLQueryItem(name: "language", value: "ru"),
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let articlesURL = urlComponents.url else
        {
            print("Error while getting URL\n")
            return nil
        }
        return articlesURL
    }
    
    func downloadArticles (category:String, page: Int, completion: @escaping(Result<[ArticleDetail], ArticleError>) -> Void) {
        guard let articlesURL = makeURL(category: category, page: page) else {return}
        
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
