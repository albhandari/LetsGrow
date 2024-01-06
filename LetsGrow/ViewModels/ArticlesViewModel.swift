//
//  ArticlesViewModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/4/24.
//

import Foundation


class ArticlesViewModel: ObservableObject{
    
    @Published var articles: [Article]?
    @Published var error: Error?
    @Published var isLoading = false
    var articlesManager: ArticlesManager
    
    init(articlesManager: ArticlesManager) {
        self.articlesManager = articlesManager
    }
    
    
    func updateArticles(){
        
        self.isLoading = true;
        self.error = nil
        
        Task {
            do {
                let fetchedArticles = try await articlesManager.getArticles()
                self.articles = fetchedArticles.articles
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
    
}
