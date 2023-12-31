//
//  CalendarCell.swift
//  WhenIChanged
//
//  Created by Joel Storr on 06.12.23.
//

import SwiftUI

struct CalendarCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    let habitColor: Color
    let dayInMonth: Bool
    let checkedDays: [CheckedDay]
    
    var body: some View {
        ZStack {
            if monthStruct().currentDay {
                
                if monthStruct().completed {
                    
                    ZStack{
                        Circle()
                            .fill(bgColor(type: monthStruct().monthType))
                            .frame(maxWidth: 25)
                        Circle()
                            .stroke(bgColor(type: monthStruct().monthType), lineWidth: 1.5)
                            .frame(maxWidth: 30)
                    }
                    
                } else {
                    Circle()
                        .fill(bgColor(type: monthStruct().monthType).opacity(0.8))
                        .frame(maxWidth: 30)
                }
            } else {
                
                if monthStruct().completed {
                    Circle()
                        .stroke(bgColor(type: monthStruct().monthType), lineWidth: 1.5)
                        .frame(maxWidth: 30)
                }
            }
            Text(monthStruct().day())
                .foregroundStyle(textColor(type: monthStruct().monthType))
        }
        .frame(maxWidth: .infinity)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.primary : Color.gray
    }
    
    func bgColor(type: MonthType) -> Color {
        return type == MonthType.Current ? habitColor : habitColor.opacity(0.5)
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        var monthStruct = MonthStruct(monthType: MonthType.Previous, dayInt: 0, currentDay: false, completed: false)
        
        if(count <= start) {
            // Returns Numbers for prev Month
            let day = daysInPrevMonth + count - start
            
            monthStruct.monthType = MonthType.Previous
            monthStruct.dayInt = day
           
            
            return monthStruct
            
        } else if (count - start > daysInMonth) {
            // Retuns Numbers for next Month
            let day = count - start - daysInMonth
            
            monthStruct.monthType = MonthType.Next
            monthStruct.dayInt = day
            
            return monthStruct
            
        }
        
        let day = count - start
        if dayInMonth {
            if CalendarHelper().currentDay(day) {
                
                
                monthStruct.monthType = MonthType.Current
                monthStruct.dayInt = day
                monthStruct.currentDay = true
                monthStruct.completed = isCompletedDay(day: day)
                
                return monthStruct
            }
            
            monthStruct.monthType = MonthType.Current
            monthStruct.dayInt = day
            monthStruct.currentDay = false
            monthStruct.completed = isCompletedDay(day: day)
            
            return monthStruct
        }
        
        monthStruct.monthType = MonthType.Current
        monthStruct.dayInt = day
        monthStruct.currentDay = false
        monthStruct.completed = isCompletedDay(day: day)
        
        return monthStruct
    
    }
    
    
    func isCompletedDay(day: Int)-> Bool{
        
        for checkedDay in checkedDays {
            
            if checkedDay.checkedDay == nil {
                continue
            }
            
            if CalendarHelper().dateInMonth(checkedDay.habitCheckedDay, monthValue: dateHolder.date)
                && CalendarHelper().matchingDay(day, completedDate: checkedDay.habitCheckedDay) {
                return true
            }
            
        }
        return false
    }
    
}

#Preview {
    CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, habitColor: Color.green, dayInMonth: true, checkedDays: [])
}
