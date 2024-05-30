//
//  TimeModel.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 5/30/24.
//

import Foundation

struct TimeModel{
    var focusTime: Int
    var quickBreakTime: Int?
    var longBreakTime: Int?
    
    init(focusTime: Int, quickBreakTime: Int? = nil, longBreakTime: Int? = nil) {
        self.focusTime = focusTime
        self.quickBreakTime = quickBreakTime
        self.longBreakTime = longBreakTime
    }
}
