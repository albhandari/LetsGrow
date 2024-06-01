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
    
    var modes = [TimerMode.focusMode, TimerMode.quickBreakMode, TimerMode.focusMode, TimerMode.longBreakMode]
    var currentMode = 0 //0: Focus Timer, 1: Quick Break Timer, 2: Focus Timer, 3: Long Break Timer
    
    //State variables
    @Published var displayTime: String //00:00 format for the view
    @Published var timeLeft: Int //time left of the timer in seconds (used for displayTime)
    @Published var isRunning: Bool //current state of the timer (paused or unpaused)
    @Published var progress: Double //represents the percent of the timer
    @Published var timerFinished: Bool //state of the timer wether it's finished or not
    
    //User input
    var initialTime: Int //Intial time the timer will run for
    var finalTime: Int = 0 //Total time actually ran by the timer
    var currentTime: Int //Total time the timer is currently running for
    
    //timer
    public var timer: AnyCancellable?
    
    var timeModel: TimeModel
    
    init(timeModel: TimeModel) {
        self.timeModel = timeModel
        initialTime = timeModel.focusTime
        displayTime = String(format: "%02d:%02d", timeModel.focusTime/60, timeModel.focusTime%60)
        currentTime = timeModel.focusTime
        timeLeft = timeModel.focusTime
        
        progress = 1.0
        isRunning = false
        timerFinished = false
    }
    
    enum TimerMode {
        case focusMode
        case quickBreakMode
        case longBreakMode
    }
    
    func changeTimer(){
        if currentMode == 3{
            currentMode = 0
        }
        else{
            currentMode += 1
        }
        switch modes[currentMode]{
        case .focusMode:
            initialTime = timeModel.focusTime
            print("Focus Time")
        case .quickBreakMode:
            initialTime = timeModel.quickBreakTime ?? timeModel.focusTime
            print("Quick Break Time")
        case .longBreakMode:
            initialTime = timeModel.longBreakTime ?? timeModel.focusTime
            print("Long Break Time")
        }
        
    }
    
    
    func startTimer(){
        //guard statement to prevent the spamming "start timer"
        guard !isRunning else {
            return
        }
        
        timerFinished = false
        isRunning = true
        //initialize the timer -> the timer "publishes" something, and whichever function "receieves" it, will do something every 1 second
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in //"_" is used because we don't really care about any values emmited by the sink closure, we just care that the event occured
                self?.decTimer()
            }
    }
    
    //what to do when timer ends
    func endTimer(){
        timerFinished = true
        changeTimer()
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
        displayTime = timeFormatter(seconds: initialTime)
        timeLeft = initialTime
        currentTime = initialTime
        progress = 1.0
    }
    
    
    func decTimer(){
        if(timeLeft > 0){
            timeLeft -= 1
            finalTime += 1
            displayTime = timeFormatter(seconds: timeLeft)
            progress = Double(timeLeft) / Double(currentTime)
        }else{
            endTimer()
            //handle what to do after the timer is done
        }
    }
    
    
    func addMinutes(minutes: Int){
        
    }
    
    func timeFormatter(seconds: Int) -> String{
        return String(format: "%02d:%02d", seconds/60, seconds%60)
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
 
 - If the user decides to start a timer (associated with nothing), when the timer finishes, a pop-up will appear asking, take a break
    or reset timer"
 
 
 Thing to consider for now:
 Do I want to make the viewmodel strictly as a timer functionality where it doesn't know if it's break or study session, all it will take is initial time input and start the timer
 - The reason to this is, if i make it open ended, then I can reuse the viewmodel initialized once to update the timer, instead of having to initialize the viewmodel over and over for new timers
 
 

 */
