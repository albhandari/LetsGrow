//
//  LetsGrowApp.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/22/24.
//

import SwiftUI

@main
struct LetsGrowApp: App {
    
    @StateObject var store = TestStoreImpl()
    
    var body: some Scene {
        WindowGroup {
            TabView{
                HomeView()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                
                ToDoView()
                    .tabItem{
                        Label("ToDo", systemImage: "book")
                    }
                
                Text("Settings")
                    .tabItem{
                        Label("Settings", systemImage: "gear")
                    }
                
            }
        }
        .environmentObject(store)
    }
}
