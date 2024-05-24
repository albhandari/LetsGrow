//
//  TimerViewModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/22/24.
//

import Foundation
import Combine


class TimerViewModel{
    
    //State variables
    @Published var timeLeft: Int
    @Published var isRunning: Bool
    
    //User Input
    var totalTime: Int
    
    //initialize the timer -> the timer "publishes" something, and whichever function "receieves" it, will do something
    //every 1 second
    public var timer: AnyCancellable?
    
    init(timeInput: Int) {
        self.totalTime = timeInput
        self.timeLeft = timeInput
        self.isRunning = false
    }
    
    
    //
    func startTimer(){
        isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in //"_" is used because we don't really care about any values emmited by the sink closure, we just care that the event occured
                self?.decTimer()
            }
    }
    
    //what to do when timer ends
    func endTimer(){
        isRunning = false
        timer?.cancel()
    }
    
    func pauseTimer(){
        isRunning = false
        timer?.cancel()
    }
    
    
    func decTimer(){
        if(self.timeLeft > 0){
            self.timeLeft -= 1
        }else{
            timer?.cancel()
            //handle what to do after the timer is done
        }
    }
    
    func addMinutes(minutes: Int){
        
    }
    
    
    
    
    
    
}


/**
Stuff to handle:
 
 - handling total time the user actually managed to stay on task
 - what happens if the user accidently closes their phone from task manager or it shuts down
 - converting seconds into a displayable format

 */
