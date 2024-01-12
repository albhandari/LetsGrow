//
//  ArticleDataService.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/6/24.
//

import Foundation

protocol ArticleDataService {
    func getArticlesData(url: URL) async throws -> [Article]
}

class ArticleDataServiceImpl: ArticleDataService{
    
//    var networkingManager: NetworkingManager
//    
//    init(networkingManager: NetworkingManager) {
//        self.networkingManager = networkingManager
//    }
    
    
    func getArticlesData(url: URL) async throws -> [Article]{
        
        let data = try await NetworkingManagerImpl.shared.fetchData(source: url)
        let articleData = try JSONDecoder().decode(ArticleData.self, from: data)
        return articleData.articles
        
    }
    
}
