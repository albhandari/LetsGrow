//
//  ArticleView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/3/24.
//

import SwiftUI

struct ArticleView: View {
    var articlesViewModel = ArticlesViewModel(articlesManager: ArticlesManager())
    
    var body: some View {
        Button("Click Me"){
            articlesViewModel.updateArticles()
            print(articlesViewModel.articles?[0].content ?? "Error")
        }
    }
}

#Preview {
    ArticleView()
}
