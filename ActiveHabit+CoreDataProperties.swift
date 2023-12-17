//
//  ActiveHabit+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension ActiveHabit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveHabit> {
        return NSFetchRequest<ActiveHabit>(entityName: "ActiveHabit")
    }

    @NSManaged public var checkAmount: Int16
    @NSManaged public var color: String?
    @NSManaged public var hasReminders: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var positiveHabit: Bool
    @NSManaged public var repeatAmount: Int16
    @NSManaged public var repeatInterval: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var time: Date?
    @NSManaged public var unit: String?
    @NSManaged public var checkedDay: NSSet?
    @NSManaged public var dayReminders: NSSet?
    @NSManaged public var weekReminders: NSSet?

}

// MARK: Generated accessors for checkedDay
extension ActiveHabit {

    @objc(addCheckedDayObject:)
    @NSManaged public func addToCheckedDay(_ value: CheckedDay)

    @objc(removeCheckedDayObject:)
    @NSManaged public func removeFromCheckedDay(_ value: CheckedDay)

    @objc(addCheckedDay:)
    @NSManaged public func addToCheckedDay(_ values: NSSet)

    @objc(removeCheckedDay:)
    @NSManaged public func removeFromCheckedDay(_ values: NSSet)

}

// MARK: Generated accessors for dayReminders
extension ActiveHabit {

    @objc(addDayRemindersObject:)
    @NSManaged public func addToDayReminders(_ value: DayReminder)

    @objc(removeDayRemindersObject:)
    @NSManaged public func removeFromDayReminders(_ value: DayReminder)

    @objc(addDayReminders:)
    @NSManaged public func addToDayReminders(_ values: NSSet)

    @objc(removeDayReminders:)
    @NSManaged public func removeFromDayReminders(_ values: NSSet)

}

// MARK: Generated accessors for weekReminders
extension ActiveHabit {

    @objc(addWeekRemindersObject:)
    @NSManaged public func addToWeekReminders(_ value: WeekReminder)

    @objc(removeWeekRemindersObject:)
    @NSManaged public func removeFromWeekReminders(_ value: WeekReminder)

    @objc(addWeekReminders:)
    @NSManaged public func addToWeekReminders(_ values: NSSet)

    @objc(removeWeekReminders:)
    @NSManaged public func removeFromWeekReminders(_ values: NSSet)

}

extension ActiveHabit : Identifiable {

}
