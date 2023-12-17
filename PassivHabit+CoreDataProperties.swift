//
//  PassivHabit+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension PassivHabit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PassivHabit> {
        return NSFetchRequest<PassivHabit>(entityName: "PassivHabit")
    }

    @NSManaged public var cardColor: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latestDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var resetDates: NSSet?

}

// MARK: Generated accessors for resetDates
extension PassivHabit {

    @objc(addResetDatesObject:)
    @NSManaged public func addToResetDates(_ value: PastResets)

    @objc(removeResetDatesObject:)
    @NSManaged public func removeFromResetDates(_ value: PastResets)

    @objc(addResetDates:)
    @NSManaged public func addToResetDates(_ values: NSSet)

    @objc(removeResetDates:)
    @NSManaged public func removeFromResetDates(_ values: NSSet)

}

extension PassivHabit : Identifiable {

}
