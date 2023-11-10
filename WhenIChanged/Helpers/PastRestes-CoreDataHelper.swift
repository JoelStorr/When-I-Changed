//
//  ResetDate-CoreDataHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.11.23.
//

import Foundation

extension PastResets {
    var wrappedResetDate: Date {
        resetDate ?? Date.now
    }
}
