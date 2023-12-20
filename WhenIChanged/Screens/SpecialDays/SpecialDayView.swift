//
//  SpecialDayView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//

import SwiftUI

struct SpecialDayView: View {
    
    @State var path: [SpecialDay] = []
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                
            }
            .navigationDestination(for: ActiveHabit.self){ value in
                    
                    
//                if goToChangeOder {
//                    
//                    ActiveHabitOrderView(habitArray: $viewModel.activeHabits)
//                } else {
//                    ActiveHabitDetailView(habit: value)
//                }
                
            }
            .navigationTitle("Active Habit")
        .listStyle(DefaultListStyle())
        .toolbar {
            ToolbarAddHabitButton()
        }
        .onAppear {
//            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
//            goToChangeOder = false
        }
        }
    }
}

#Preview {
    SpecialDayView()
}
