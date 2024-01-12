//
//  ArticleView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/3/24.
//

import SwiftUI

struct ArticleRowView: View {
    
    let article: Article
    
    var body: some View {
        
        HStack{
            Image("landscape")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading){
                Text(article.title)
                    .font(.headline)
                Text(article.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
                    .truncationMode(.tail)
            }
            
            Spacer()
        }
        .padding()
        
        
    }
}
