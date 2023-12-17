//
//  CheckedDay+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension CheckedDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckedDay> {
        return NSFetchRequest<CheckedDay>(entityName: "CheckedDay")
    }

    @NSManaged public var checkedDay: Date?
    @NSManaged public var activeHabit: ActiveHabit?

}

extension CheckedDay : Identifiable {

}
