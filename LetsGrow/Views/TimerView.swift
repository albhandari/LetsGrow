//
//  TimerView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/22/24.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject var timerVM = TimerViewModel(timeInput: 100)

    
    var body: some View {
        
        ZStack{
            
            Text("Time Remaining \(timerVM.timeLeft)")
            
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.08)
                .foregroundColor(.black)
                .frame(width: 200, height: 200)
            
            Circle()
                .trim(from: 0, to: timerVM.progress)
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .opacity(0.7)
                .foregroundColor(.green)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(270.0))
            
            
        }
        
        HStack{
            Button("Start Timer") {
                timerVM.startTimer()
            }
            
            Button("Pause Timer") {
                timerVM.pauseTimer()
            }
            
            Button("Reset Timer") {
                timerVM.resetTimer()
            }
        }
        
        
    }
}

#Preview {
    TimerView()
}
