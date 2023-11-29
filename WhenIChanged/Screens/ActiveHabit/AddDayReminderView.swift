//
//  AddDayReminderView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 16.11.23.
//

import SwiftUI

struct AddDayReminderView: View {

    @ObservedObject var reminder: DayReminderData

    var body: some View {
        DatePicker("Select Reminder", selection: $reminder.time, displayedComponents: .hourAndMinute)
    }
}
