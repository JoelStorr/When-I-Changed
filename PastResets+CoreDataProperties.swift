//
//  PastResets+CoreDataProperties.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//
//

import Foundation
import CoreData


extension PastResets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PastResets> {
        return NSFetchRequest<PastResets>(entityName: "PastResets")
    }

    @NSManaged public var resetDate: Date?
    @NSManaged public var habit: PassivHabit?

}

extension PastResets : Identifiable {

}
