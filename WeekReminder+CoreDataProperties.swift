//
//  WeekReminder+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension WeekReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekReminder> {
        return NSFetchRequest<WeekReminder>(entityName: "WeekReminder")
    }

    @NSManaged public var day: Int16
    @NSManaged public var notificationId: String?
    @NSManaged public var time: Date?
    @NSManaged public var habit: ActiveHabit?

}

extension WeekReminder : Identifiable {

}
