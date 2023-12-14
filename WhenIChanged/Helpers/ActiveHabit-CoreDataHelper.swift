//
//  ActiveHabit-CoreDataHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 16.11.23.
//

import Foundation

extension ActiveHabit {

    
    var habitId: String {
        get { id?.uuidString ?? "0" }
    }
    
    
    var habitCheckAmount: Int {
        get { Int(checkAmount) ?? 0 }
        set { checkAmount = Int16(newValue)}
    }

    var habitColor: String {
        get { color ?? "" }
        set { color = newValue }
    }

    var habitHasReminders: Bool {
        get { hasReminders ?? false }
        set { hasReminders = newValue }
    }

    var habitName: String {
        get { name ?? "" }
        set { name = newValue}
    }

    var habitPositiveHabit: Bool {
        get { positiveHabit ?? true }
        set { positiveHabit = newValue }
    }

    var habitRepeatAmount: Int {
        get { Int(repeatAmount) ?? 0 }
        set { repeatAmount = Int16(newValue)}
    }

    var habitRepeatInterval: String {
        get { repeatInterval ?? "" }
        set { repeatInterval = newValue }
    }

    var habitStartDate: Date {
        get { startDate ?? Date.now }
        set { startDate = newValue }
    }

    var habitTime: Date {
        get { time ?? Date.now }
        set { time = newValue }
    }

    var habitUnit: String {
        get { unit ?? "" }
        set { unit = newValue }
    }

    var habitCheckedDay: [CheckedDay] {
        let set = checkedDay as? Set<CheckedDay> ?? []
        return set.sorted {
            $0.habitCheckedDay > $1.habitCheckedDay
        }
    }
    
    var habitDayReminders: [DayReminder] {
        let set = dayReminders as? Set<DayReminder> ?? []
        return set.map{item in return item}
    }
    
    var habitWeekReminders: [WeekReminder] {
        let set = dayReminders as? Set<WeekReminder> ?? []
        return set.map{item in return item}
    }
    
}

extension CheckedDay {
    var habitCheckedDay: Date {
        get { checkedDay ?? Date.now }
        set { checkedDay = newValue }
    }
}


extension DayReminder {
    var dayReminderTime: Date {
        get { time ?? Date.now }
        set { time = newValue }
    }
    
    var dayReminderNotificationId: String {
        get { notificationId ?? "" }
        set { notificationId = newValue }
    }
}


extension WeekReminder {
    var weekReminderDay: Int {
        get { Int(day) }
        set { day = Int16(newValue) }
    }
    
    var weekReminderTime: Date {
        get {time ?? .now }
        set {time = newValue }
    }
    
    var weekReminderNotificationId: String {
        get {notificationId ?? "" }
    }
}
