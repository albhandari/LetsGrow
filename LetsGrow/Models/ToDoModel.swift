//
//  ToDoModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 6/25/24.
//

import Foundation


struct ToDo: Identifiable{
    let id = UUID()
    let title: String
    let description: String
    let dueDate: Date
    let completed: Bool

}
