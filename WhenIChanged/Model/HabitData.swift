//
//  HabitData.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import Foundation


class HabitData : Identifiable, ObservableObject{
    static func == (lhs: HabitData, rhs: HabitData) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    var habbitName : String
    var startDate : Date = Date.now
    var latestDate : Date = Date().addingTimeInterval(-10) // Nedds to be Date.now when ever it gets reseted
    var pastResets : [Date] = [Date.now]
    
    init(habbitName: String) {
        self.habbitName = habbitName
    }
    
    var startDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: startDate)
    }
    
    func timeSpan()-> String{
        
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: latestDate, to: Date.now)

           let seconds = "\(difference.second ?? 0)s"
           let minutes = "\(difference.minute ?? 0)m"
           let hours = "\(difference.hour ?? 0)h" + " " + minutes
           let days = "\(difference.day ?? 0)d" + " " + hours

           if let day = difference.day, day          > 0 { return days }
           if let hour = difference.hour, hour       > 0 { return hours }
           if let minute = difference.minute, minute > 0 { return minutes }
           if let second = difference.second, second > 0 { return seconds }
           return ""
        
        
        
        
        /*
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: latestDate, relativeTo: Date())
        return relativeDate
        */
        
        //return latestDate.distance(to: Date.now)
    }
    
}
