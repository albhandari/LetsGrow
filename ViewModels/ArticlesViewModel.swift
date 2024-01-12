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
    
    var articleDataService: ArticleDataService
    
    init(articleDataService: ArticleDataService) {
        self.articleDataService = articleDataService
    }
    
//    @MainActor
//    func updateArticles(url: String) async{
//        let articles = try? await articleDataService.getArticlesData(url: url)
//        if let  fetchedArticles = articles{
//            self.articles = fetchedArticles
//            print(self.articles?[0].content ?? "ERROR: Nothing in articles array to fetch")
//        }
//        else{
//            print("Error in vm: updateArticles()")
//        }
//    }
    @MainActor
    func fetchArticles() async{
        guard let url = URL(string: Constants.articleUrl) else {return}
        let articles = try? await articleDataService.getArticlesData(url: url)
        if let  fetchedArticles = articles{
            self.articles = fetchedArticles
            print(self.articles?[0].content ?? "ERROR: Nothing in articles array to fetch")
        }
        else{
            print("Error in vm: updateArticles()")
        }
    }
    
}
