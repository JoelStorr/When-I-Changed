//
//  CalendarHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 06.12.23.
//

import Foundation

class DateHolder: ObservableObject {
    @Published var date = Date()
}

class CalendarHelper {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    
    func monthYearString(_ date: Date) -> String {
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: date)
    }
    
    func plusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1 ,to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1 ,to: date)!
    }
    
    func daysInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func dateInMonth(_ date: Date, monthValue: Date = .now) -> Bool {
        return calendar.isDate(date, equalTo: monthValue, toGranularity: .month)
    }
    
    func currentDay(_ dateNum: Int) -> Bool {
        return dateNum == calendar.component(.day, from: .now)
    }
    
    func matchingDay(_ dateNum: Int, completedDate: Date) -> Bool {
        return dateNum == calendar.component(.day, from: completedDate)
    }
    func dateInt(_ date: Date) -> Int {
        return calendar.component(.day, from: date)
    }

}

