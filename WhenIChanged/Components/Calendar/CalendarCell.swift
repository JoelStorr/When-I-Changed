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
    
    var body: some View {
        ZStack {
           
            if monthStruct().currentDay {
                Circle()
//                    .stroke(bgColor(type: monthStruct().monthType), lineWidth: 1)
                    
                    .fill(bgColor(type: monthStruct().monthType))
                    .frame(maxWidth: 30)
            } else {
                Circle()
                    .stroke(bgColor(type: monthStruct().monthType), lineWidth: 1)
                    .frame(maxWidth: 30)
    //               .fill(bgColor(type: monthStruct().monthType))
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
        if(count <= start) {
            // Returns Numbers for prev Month
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day, currentDay: false)
        } else if (count - start > daysInMonth) {
            // Retuns Numbers for next Month
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day, currentDay: false)
        }
        
        let day = count - start
        if dayInMonth {
            if CalendarHelper().currentDay(day) {
                return MonthStruct(monthType: MonthType.Current, dayInt: day, currentDay: true)
            }
            return MonthStruct(monthType: MonthType.Current, dayInt: day, currentDay: false)
        }
        return MonthStruct(monthType: MonthType.Current, dayInt: day, currentDay: false)
    }
    
}

#Preview {
    CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, habitColor: Color.green, dayInMonth: true)
}
