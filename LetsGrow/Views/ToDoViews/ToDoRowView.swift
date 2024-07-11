//
//  ToDoRowView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 7/9/24.
//

import SwiftUI

struct ToDoRowView: View {
    
    var toDo: ToDo
    
    var body: some View {
        
        HStack{
            VStack(alignment: .leading){
                Text(toDo.title)
                    .bold()
                Text(toDo.description)
                    .lineLimit(1)
            }
            .padding()
            Spacer()
            
            Image(systemName: "checkmark.square.fill")
                .padding()
            
        }
        .background(Color(Color.appBlue.opacity(0.7)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 100)))
        
        
        
    }
}

#Preview {
    ToDoRowView(toDo: ToDo(title: "Water Plants", description: "Water the rose and sunflower asap. Also make sure to limit the amount of water to tulasi", dueDate: Date(), completed: false))
}
