//
//  HomeViewModel.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import Foundation



extension HomeView {
    final class ViewModel: ObservableObject {
        @Published var cards: [PassivHabit] = []

        @Published var changeView: HomeViewType = .habitView
        @Published var addingHabit: Bool = false
        @Published var addingAutoHabit: Bool = true
        @Published var detailEditing: Bool = false
        
        @Published var selectedHabit: PassivHabit = PassivHabit()

        func loadPassivHabits () {
            cards = StorageProvider.shared.loadAllPassivHabits()
        }
    }
}
