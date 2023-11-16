//
//  AddWeekReminderView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 16.11.23.
//

import SwiftUI

struct AddWeekReminderView: View {
    
    @ObservedObject var reminder: WeekReminderData
    
    
    var body: some View {
        HStack {
            Picker(selection: $reminder.day, label: Text("Select the day")) {
                ForEach(0..<Days.allCases.count, id: \.self) { index in
                    Text("\(Days.allCases[index].rawValue)").tag(index)
                }
            }
            Spacer()
                .frame(width: 20)
            DatePicker("", selection: $reminder.time, displayedComponents: .hourAndMinute)
                .frame(width: 50)
        }
    }
}


