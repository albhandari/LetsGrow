//
//  TimerModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/24/24.
//

import Foundation

struct TimerModel{
    var focusTime: Int
    var quickBreakTime: Int
    var longBreakTime: Int?
    
    init(focusTime: Int, quickBreakTime: Int, longBreakTime: Int? = nil) {
        self.focusTime = focusTime
        self.quickBreakTime = quickBreakTime
        self.longBreakTime = longBreakTime
    }
}
