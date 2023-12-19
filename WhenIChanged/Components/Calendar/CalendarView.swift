//
//  CalendarView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 06.12.23.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var dateHolder = DateHolder()
    
    let habitColor: Color
    let checkedDays: [CheckedDay] 
    @State var startMonday: Bool = false
    
    var body: some View {
        
        VStack(spacing: 1) {
            DateScrollView(habitColor: habitColor)
                .environmentObject(dateHolder)
                .padding()
            dayOfWeekStack
            calanderGrid
        }
        .onAppear{
            startMonday = StorageProvider.shared.globalSetupClass.weekStartsMonday
        }
    }
    
    var dayOfWeekStack: some View {
        
        if startMonday {
            HStack(spacing: 1) {
                Text("Mon").dayOfWeek()
                Text("Tue").dayOfWeek()
                Text("Wed").dayOfWeek()
                Text("Thu").dayOfWeek()
                Text("Fri").dayOfWeek()
                Text("Sat").dayOfWeek()
                Text("Sun").dayOfWeek()
            }
        } else {
            HStack(spacing: 1) {
                Text("Sun").dayOfWeek()
                Text("Mon").dayOfWeek()
                Text("Tue").dayOfWeek()
                Text("Wed").dayOfWeek()
                Text("Thu").dayOfWeek()
                Text("Fri").dayOfWeek()
                Text("Sat").dayOfWeek()
            }
        }
        
        
    }
    
    var calanderGrid: some View {
        VStack(spacing: 1) {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth, startMonday: startMonday)
            let previousMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPreviousMonth = CalendarHelper().daysInMonth(previousMonth)
            let dayInMonth = CalendarHelper().dateInMonth(dateHolder.date)
            
            ForEach(0..<6) { row in
                HStack(spacing: 1) {
                    ForEach(1..<8) { column in
                            let count = column + (row * 7)
                        CalendarCell(
                            count: count,
                            startingSpaces: startingSpaces,
                            daysInMonth: daysInMonth,
                            daysInPrevMonth: daysInPreviousMonth,
                            habitColor: habitColor,
                            dayInMonth: dayInMonth,
                            checkedDays: checkedDays
                        ) // TODO: Change Today
                            .environmentObject(dateHolder)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    CalendarView(habitColor: Color.green, checkedDays: [])
}

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
