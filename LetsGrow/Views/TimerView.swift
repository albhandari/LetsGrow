//
//  TimerView.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/22/24.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject var timerVM = TimerViewModel(timeInput: 20)
    
    var body: some View {
    
        Text("Time Remaining \(timerVM.timeLeft)")
        
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

#Preview {
    TimerView()
}
