//
//  ActiveHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 12.11.23.
//

import SwiftUI

struct ActiveHabitView: View {
    
    @State var activeHabits: [ActiveHabit] = []
    
    var body: some View {
        
        NavigationStack {
            NavigationLink {ActiveHabitAddView()} label: {
                List {
                    ForEach(activeHabits, id: \.self) { habit in
                        Text("\(habit.name ?? "No Name")")
                    }
                }
            }
            .toolbar {
                ToolbarAddHabitButton()
            }
            .onAppear {
                activeHabits = StorageProvider.shared.loadAllActiveHabits()
            }
        }
    }
}
