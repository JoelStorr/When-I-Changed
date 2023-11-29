//
//  ActiveHabitDetailView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 22.11.23.
//

import SwiftUI

struct ActiveHabitDetailView: View {
    
    @ObservedObject var habit: ActiveHabit
    
    var body: some View {
        VStack {
            
            Spacer()
            HStack {
                Button{
                    StorageProvider.shared.removeCheckFromActiveHabit(habit)
                } label: {
                    Text("-")
                        .font(.title)
                }
                
                Text("\(habit.habitCheckAmount) / \(habit.habitRepeatAmount)")
                
                
                Button {
                    StorageProvider.shared.addCheckToActiveHabit(habit)
                } label: {
                    Text("+")
                        .font(.title)
                }
            }
            Spacer()
            
        }.navigationTitle(habit.habitName)
    }
}

