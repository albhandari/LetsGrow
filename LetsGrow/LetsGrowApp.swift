//
//  LetsGrowApp.swift
//  LetsGrow
//
//  Created by Alex on 5/4/26.
//

import SwiftUI

@main
struct LetsGrowApp: App {
    
    @State private var appStore = AppStore()
    
    var body: some Scene {
        WindowGroup {
            BrainstormView()
                .environment(appStore)
        }
    }
}
