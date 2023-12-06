//
//  MonthStruct.swift
//  WhenIChanged
//
//  Created by Joel Storr on 06.12.23.
//

import Foundation

struct MonthStruct {
    var monthType: MonthType
    var dayInt: Int
    
    func day() -> String {
        return String(dayInt)
    }
    
    
}

enum MonthType {
    case Previous
    case Current
    case Next
}

