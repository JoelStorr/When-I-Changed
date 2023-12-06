//
//  DateScrollView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 05.12.23.
//

import SwiftUI

import SwiftUI

struct DateScrollView: View {
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: previousMonth) {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(.title.bold())
                
            }
            Text(CalendarHelper().monthYearString(dateHolder.date))
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            Button(action: nextMonth) {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(.title.bold())
                
            }
            Spacer()
        }
    }
    
    func previousMonth(){
        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
    }
    func nextMonth() {
        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
    }
    
}

#Preview {
    DateScrollView()
}
