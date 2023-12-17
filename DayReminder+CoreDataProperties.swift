//
//  DayReminder+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension DayReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayReminder> {
        return NSFetchRequest<DayReminder>(entityName: "DayReminder")
    }

    @NSManaged public var notificationId: String?
    @NSManaged public var time: Date?
    @NSManaged public var habit: ActiveHabit?

}

extension DayReminder : Identifiable {

}
