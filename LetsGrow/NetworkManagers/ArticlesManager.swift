//
//  ArticlesManager.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/3/24.
//

import Foundation

class ArticlesManager{
    
    var articles:[Article]?
    
    enum ArticleError: Error{
        case invalidURL
        case invalidResponse
        case invalidData
        
    }
    
    func getArticles() async throws -> ArticleResponse{
        let endPoint = "https://newsapi.org/v2/everything?q=gardening&pageSize=2&apiKey=4e90bdb3123d4cdd911306ad4d3756d2"
        print(endPoint)
        guard let url = URL(string: endPoint) else{
            throw ArticleError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw ArticleError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(ArticleResponse.self, from: data)
        } catch{
            throw ArticleError.invalidData
        }
    }
    
    
}
