//
//  ToDoView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 6/30/24.
//

import SwiftUI

struct ToDoView: View {

    @StateObject private var toDoVM = ToDoViewModel()
    @EnvironmentObject var store: TestStoreImpl
    
    
    
    var body: some View {
        VStack{
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
                    Button(action: toDoVM.toggleSheet){
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
                        toDoVM.updateDate(date: Date())
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
                    ForEach(toDoVM.currentToDo){ toDo in
                        ToDoRowView(toDo: toDo)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $toDoVM.isShowingSheet, content: {
            
            
            DatePicker(
                "Add ToDo",
                selection: $toDoVM.selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding(.top)
            .tint(Color.appBlue)
            
            TextField("Task Title", text: $toDoVM.toDoTitle)
                .textFieldStyle(.roundedBorder)
                .padding([.horizontal, .bottom])
    
            TextField("Task Description", text: $toDoVM.toDoDescription, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .lineLimit(3, reservesSpace: true)
            
            Button(action: {
                toDoVM.addToDo()
            }){
                Text("Add Task")
                    .foregroundStyle(Color(Color.white))
                    .padding(5)
                    .bold()
                    .frame(maxWidth: . infinity)
            }
            .background(Color.appBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .buttonStyle(.bordered)
            .padding()
            
            
            
            
            
            
            Spacer()
            
            
            .presentationDetents([.fraction(0.82), .fraction(0.99)])
        })
        
    }
}


#Preview {
    ToDoView()
}
