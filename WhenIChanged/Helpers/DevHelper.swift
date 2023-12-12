//
//  DevHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 12.12.23.
//

import Foundation

class DevHelper {
    
    var dateArray: [Date] = []
    var activeHabit: ActiveHabit?
    func createActiveHabit() {
        
        
        activeHabit =  StorageProvider.shared.saveActiveHabit(
            name: "DevGenHabit",
            color: ActiveHabitColor.yellow,
            repeatInterval: "day",
            time: .now,
            unit: UnitTypes.numberOfTimes.rawValue,
            repeatAmount: 2,
            reminders: false,
            reminderType: 0,
            addedWeekReminders: [],
            addedDayReminders: []
        )
        
        
        
        
        if activeHabit != nil {
            generateDates()
            addCheckedDaysToHabit()
        }
        
        
    }
    
    
    func generateDates(){
        
        for num in 1..<30 {
            if num % 2 == 0 {
                
                
                
                // Create String
                let string = "\(num)/11/2023"
                
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                
                // Set Date Format
                dateFormatter.dateFormat = "dd/MM/yy"
                
                // Convert String to Date
                let date =  dateFormatter.date(from: string)
                
                dateArray.append(date!)
            }
        }
        
        for num in 1..<CalendarHelper().dateInt(.now) {
            if num % 2 != 0 {
                
                // Create String
                let string = "\(num)/12/2023"
                
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                
                // Set Date Format
                dateFormatter.dateFormat = "dd/MM/yy"
                
                // Convert String to Date
                let date =  dateFormatter.date(from: string)
                
                dateArray.append(date!)
            }
        }
        
        print(dateArray)
    }
    
    
    func addCheckedDaysToHabit () {
        guard let activeHabit = activeHabit else {
            return
        }
        
        for date in dateArray {
            StorageProvider.shared.addCheckToActiveHabit(activeHabit, date: date)
            StorageProvider.shared.addCheckToActiveHabit(activeHabit, date: date)
            
            activeHabit.habitCheckAmount = 0
            StorageProvider.shared.save()
        }
        
        print(activeHabit.habitCheckedDay.count)
    }
    
    
    
    
    
    
}
