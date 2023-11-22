//
//  ActiveHabitViewModel.swift
//  WhenIChanged
//
//  Created by Joel Storr on 22.11.23.
//

import Foundation

extension ActiveHabitView {
    @MainActor class ViewModel: ObservableObject {
        @Published var activeHabits = [ActiveHabit]()
    }
}
