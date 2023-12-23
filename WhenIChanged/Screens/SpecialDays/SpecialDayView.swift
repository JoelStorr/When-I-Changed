//
//  SpecialDayView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//

import SwiftUI

struct SpecialDayView: View {
    
    @State var path: [SpecialDay] = []
    @State var goToChangeOder: Bool = false
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                
            }
            .navigationDestination(for: ActiveHabit.self){ value in
                    
                    
                if goToChangeOder {
                    
//                    ActiveHabitOrderView(habitArray: $viewModel.activeHabits)
                } else {
                    SpecialDayAddView() // TODO: Feed habit back in
                }
                
            }
            .navigationTitle("Active Habit")
        .listStyle(DefaultListStyle())
        .toolbar {
            ToolbarAddHabitButton()
        }
        .onAppear {
            path = StorageProvider.shared.loadAllSpecialDays()
            goToChangeOder = false
        }
        }
    }
}

#Preview {
    SpecialDayView()
}
