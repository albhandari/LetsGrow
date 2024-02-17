//
//  PlantView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/12/24.
//

import SwiftUI

struct PlantView: View {
    
    @State private var isShowing = true;
    @State private var searchPlant = ""
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                Text("Add Plant")
                    .font(.largeTitle) // You can adjust the font as needed
                    .padding(.top, 20) // Add padding to move it a bit from the very top edge
                Spacer() // Pushes the content to the top
            }
                .sheet(isPresented: $isShowing){
                    HStack{
                        TextField("Search Plant", text: $searchPlant)
                        
                    }
                    .presentationDetents([.height(100), .medium, .large])
                    .interactiveDismissDisabled()
                }

        }
    }
}

#Preview {
    PlantView()
}
