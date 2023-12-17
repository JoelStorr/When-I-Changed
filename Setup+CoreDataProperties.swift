//
//  Setup+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension Setup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setup> {
        return NSFetchRequest<Setup>(entityName: "Setup")
    }

    @NSManaged public var lastDayReset: Date?
    @NSManaged public var lastWeekReset: Date?

}

extension Setup : Identifiable {

}
