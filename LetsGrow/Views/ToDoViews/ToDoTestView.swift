//
//  ToDoView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 6/30/24.
//

import SwiftUI

struct ToDoTestView: View {

    @StateObject private var toDoVM = ToDoViewModel()
    
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "list.dash")
                    .foregroundStyle(.white)
                Spacer()
                Text(toDoVM.formatDate(toDoVM.currentDate))
                    .foregroundStyle(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                Image(systemName: "timer")
                    .foregroundStyle(.white)
            }
            .padding()
            
            HStack{
                VStack(alignment: .leading){
                    Text(toDoVM.formatDate(toDoVM.currentDate))
                        .foregroundStyle(Color(Color.white))
                        .font(.system(size: 25))
                        //.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("6 Tasks")
                        .foregroundStyle(Color(Color.white))
                }
                Spacer()
                Button(action: toDoVM.updateSampleToDos){
                    Text("Add To Do")
                        .foregroundStyle(Color(Color.white))
                        .padding(5)
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            .padding()
            
            
        }
        .background(Color(Color.appBlue))
        VStack{
            HStack{
                Button(action: toDoVM.decDate){
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(Color(Color.appBlue))
                        .padding(5)
                        .bold()
                }
                .buttonStyle(.bordered)
                .tint(.white)
                Spacer()
                Button(action: {
                    toDoVM.updateDate(date: toDoVM.today)
                }){
                    Text("Today")
                        .foregroundStyle(Color(Color.appBlue))
                        .padding(5)
                        .bold()
                }
                .buttonStyle(.bordered)
                .tint(.white)
                Spacer()
                Button(action: toDoVM.incDate){
                    Image(systemName: "arrow.forward")
                        .foregroundStyle(Color(Color.appBlue))
                        .padding(5)
                        .bold()
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            
            Text("My Tasks")
                .font(.system(size: 25))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView(.vertical){
                ForEach(toDoVM.toDos){ toDo in
                    ToDoRowView(toDo: toDo)
                        .padding(.horizontal)
                }

            }
            
            Spacer()
        }
        
    }
}

extension ToDoTestView {
    func addToDo() -> Void {}
}



#Preview {
    ToDoTestView()
}
