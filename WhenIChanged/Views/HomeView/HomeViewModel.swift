//
//  HomeViewModel.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import Foundation


extension HomeView {
    final class ViewModel: ObservableObject {
        @Published var cards = [HabitData(habbitName: "Smoking") ]
        
        @Published var showEditView = false
        @Published var addingHabit: Bool = false
        @Published var addingAutoHabit: Bool = true
        
        
        func saveNewHabit(name:String) -> Void{
            let habit = HabitData(habbitName: name)
            cards.append(habit)
            showEditView.toggle()
        }
        
        
        
        
        
    }
}
