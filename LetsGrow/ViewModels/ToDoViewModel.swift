//
//  ToDoViewModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 7/9/24.
//

import Foundation

class ToDoViewModel: ObservableObject{
    
    @Published var isShowingSheet = true
    
    @Published var today: Date = Date.now
    @Published var currentDate: Date = Date.now
    
    @Published var toDos: [ToDo] = []
    @Published var currentToDo: [ToDo] = []
    
    init(today: Date, currentDate: Date) {
        self.today = today
        self.currentDate = currentDate
        
        self.updateSampleToDos()
    }
    
    init(){ 
        
        self.updateSampleToDos()
    }
    
    func incDate(){ //Incriment currentDate by 1 day or 86400 seconds
        self.currentDate = Date(timeInterval: 86400, since: self.currentDate)
        self.updateCurrentToDos()
        print(currentDate)
    }
    
    func decDate(){ //Decrement currentDate by 1 day or 86400 seconds
        self.currentDate = Date(timeInterval: -86400, since: self.currentDate)
        self.updateCurrentToDos()
        print(currentDate)
    }
    
    func updateDate(date: Date) -> Void{ //update currentDate by specified date
        self.currentDate = date
        self.updateCurrentToDos()
    }
    
    func formatDate(_ date: Date) -> String{
        let dateFormatter = DateFormatter() //should I init DateFormatter() here or at VM init level if I am going to use it multiple times?
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
        
    }
    
    func fetchToDos(){
        
    }
    
    func updateCurrentToDos() {
        let calendar = Calendar.current
        self.currentToDo = toDos.filter { calendar.isDate($0.dueDate, inSameDayAs: self.currentDate) }
        
        
    }
    
    func updateSampleToDos() {
        let sampleTodos = [
            ToDo(title: "Buy groceries", description: "Milk, Bread, Eggs", dueDate: Date(timeInterval: 86400, since: Date()), completed: false),
            ToDo(title: "Walk the dog", description: "Evening walk in the park", dueDate: Date(timeInterval: -86400, since: Date()), completed: false),
            ToDo(title: "Read a book", description: "Finish reading 'Swift Programming'", dueDate: Date(timeInterval: -2 * 86400, since: Date()), completed: false),
            ToDo(title: "Exercise", description: "30 minutes of cardio", dueDate: Date(), completed: false),
            ToDo(title: "Clean the house", description: "Living room and kitchen", dueDate: Date(), completed: false),
            ToDo(title: "Write code", description: "Work on the LetsGrow app", dueDate: Date(timeInterval: 86400, since: Date()), completed: false),
            ToDo(title: "Call parents", description: "Catch up with family", dueDate: Date(), completed: false),
            ToDo(title: "Plan weekend trip", description: "Research destinations and book hotel", dueDate: Date(), completed: false),
            ToDo(title: "Pay bills", description: "Electricity, water, and internet", dueDate: Date(timeInterval: -86400, since: Date()), completed: false),
            ToDo(title: "Cook dinner", description: "Try a new recipe", dueDate: Date(timeInterval: 2 * 86400, since: Date()), completed: false)
        ]

        toDos.append(contentsOf: sampleTodos)
        self.updateCurrentToDos()
    }
    
    
}
