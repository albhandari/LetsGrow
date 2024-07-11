//
//  Store.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 6/25/24.
//

import Foundation

protocol Store: ObservableObject {
    
    func getToDo() -> ToDo
    
    func updateToDo(type: ToDo) -> Void
    
}

class TestStoreImpl: ObservableObject, Store{
    
    private var toDo: ToDo?
    
    
    func getToDo() -> ToDo {
        return ToDo(
                title: "Test ToDo",
                description: "This is a test ToDo item.",
                dueDate: Date(),
                completed: false
            )
    }
    
    func updateToDo(type: ToDo) {
        self.toDo = type
    }
    
    
}


