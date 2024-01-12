//
//  ArticlesPageView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/3/24.
//

import SwiftUI

struct ArticlesView: View {
    
    @StateObject var articlesVM = ArticlesViewModel(articleDataService: ArticleDataServiceImpl())
    
    var body: some View {
        
        Button("Click Me"){
            Task{
                await articlesVM.fetchArticles()
            }
        }
        
        if let articles = articlesVM.articles, !articles.isEmpty{
            List(articles) { article in
                ArticleRowView(article: article)
            }
        }
    }
}

#Preview {
    ArticlesView()
}
