//
//  ActiveHabit-CoreDataHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 16.11.23.
//

import Foundation

extension ActiveHabit {
    
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
    
    var habitCheckedDay : [CheckedDay] {
        let set = checkedDay as? Set<CheckedDay> ?? []
        return set.sorted {
            $0.habitCheckedDay > $1.habitCheckedDay
        }
    }
    
}



extension CheckedDay {
    var habitCheckedDay: Date {
        get { checkedDay ?? Date.now }
        set { checkedDay = newValue }
    }
}