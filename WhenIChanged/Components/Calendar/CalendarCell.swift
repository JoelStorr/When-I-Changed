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
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(bgColor(type: monthStruct().monthType), lineWidth: 1)
                
//                .fill(bgColor(type: monthStruct().monthType))
                
                .frame(maxWidth: 30)
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
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        } else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
    
}

#Preview {
    CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, habitColor: Color.green)
}
