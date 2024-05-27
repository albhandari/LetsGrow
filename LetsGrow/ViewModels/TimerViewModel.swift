//
//  TimerViewModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/22/24.
//

import Foundation
import Combine


//This class will be as generic as possible
//It will serve as only starting a timer
@MainActor
class TimerViewModel: ObservableObject{
    
    //State variables
    @Published var timeLeft: Int
    @Published var isRunning: Bool
    @Published var progress: Double
    @Published var timerFinished: Bool
    
    //User input
    var initialTime: Int //Intial time the timer will run for
    var finalTime: Int = 0 //Total time actually ran by the timer
    var currentTime: Int //Total time the timer is currently running for
    
    //timer
    public var timer: AnyCancellable?
    
    init(initialTime: Int) {
        self.initialTime = initialTime
        self.currentTime = initialTime
        self.timeLeft = initialTime
        
        self.progress = 1.0
        self.isRunning = false
        self.timerFinished = false
    }
    

    
    func startTimer(){
        //guard statement to prevent the spamming "start timer"
        guard !isRunning else {
            return
        }
        isRunning = true
        //initialize the timer -> the timer "publishes" something, and whichever function "receieves" it, will do something
        //every 1 second
        timer = Timer.publish(every: 1, on: .main, in: .common) //what happens if i spam startTimer()
            .autoconnect()
            .sink{ [weak self] _ in //"_" is used because we don't really care about any values emmited by the sink closure, we just care that the event occured
                self?.decTimer()
            }
    }
    
    //what to do when timer ends
    func endTimer(){
        timerFinished = true
        resetTimer()
    }
    
    func pauseTimer(){
        isRunning = false
        timer?.cancel()
    }
    
    func resetTimer(){
        //Wanna ask "Are you sure you want to reset" -> needs to be implenented
        if isRunning {
            pauseTimer()
        }
        
        timerFinished = false
        timeLeft = initialTime
        currentTime = initialTime
        progress = 1.0
    }
    
    
    func decTimer(){
        if(self.timeLeft > 0){
            self.timeLeft -= 1
            self.finalTime += 1
            self.progress = Double(timeLeft) / Double(currentTime)
        }else{
            endTimer()
            //handle what to do after the timer is done
        }
    }
    
    
    func addMinutes(minutes: Int){
        
    }
    
    
    
    
    
    
}

//start random timer

/**
Stuff to handle:
 
 - handling total time the user actually managed to stay on task
 - what happens if the user accidently closes their phone from task manager or it shuts down
 - converting seconds into a displayable format
 - the application for now updates totalTime when decTimer() runs -> Maybe want to optimize time process
    - for example: maybe if the user pauses, is when you add to total timer with the total time elapsed from initial
    - for example: when the the timer fully ends, is when u add the total time elapsed
    - MAKE SURE TO CONSIDER BOTTLENECKS THO: what if the user closes phone, add extra time, etc.
 
 
 Thing to consider for now:
 Do I want to make the viewmodel strictly as a timer functionality where it doesn't know if it's break or study session, all it will take is initial time input and start the timer
 - The reason to this is, if i make it open ended, then I can reuse the viewmodel initialized once to update the timer, instead of having to initialize the viewmodel over and over for new timers
 
 

 */
