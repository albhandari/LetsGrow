//
//  TimerCircleView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/24/24.
//

import SwiftUI

struct TimerCircleView: View{
    
    
    
    var body: some View {
        
        ZStack{
            
            Text("Hello")
            
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.08)
                .foregroundColor(.black)
                .frame(width: 200, height: 200)
            
            Circle()
                .trim(from: 0, to: 0.10)
                .stroke(lineWidth: 20)
                .opacity(0.08)
                .foregroundColor(.red)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(270.0))
            
            
        }
    }
}


#Preview{
    TimerCircleView()
}
