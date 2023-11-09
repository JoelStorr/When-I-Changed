//
//  PassivHabit-CoreDataHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import Foundation

// removes Optionality from CoreData types
extension PassivHabit {
    var habitName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    var habitColor: String {
        get { cardColor ?? "" }
        set { cardColor = newValue }
    }
    
    var habitStartDate: Date {
        startDate ?? .now
    }
    
    var habitLatestDate: Date {
        latestDate ?? .now
    }
    
    
    var startDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: habitStartDate)
    }
    
    
    func timeSpan()-> String{
        
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: habitLatestDate, to: Date.now)
        
        let seconds = "\(difference.second ?? 0)s"
        
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let minutes2 = "\(difference.minute ?? 0)m"
        
        let hours = "\(difference.hour ?? 0)h" + " " + minutes2
        let hours2 = "\(difference.hour ?? 0)h"
        
        let days = "\(difference.day ?? 0)d" + " " + hours
        let days2 = "\(difference.day ?? 0)d"
        
        // let yeary = "\(difference.year ?? 0)y" + " " + days2
        
        if let highDay = difference.day, highDay > 100 { return days2 }
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
