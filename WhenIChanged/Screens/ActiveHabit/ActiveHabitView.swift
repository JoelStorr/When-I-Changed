//
//  ActiveHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 12.11.23.
//

import SwiftUI

struct ActiveHabitView: View {
    
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        
        NavigationStack {
            
                List {
                    ForEach($viewModel.activeHabits, id: \.id) { $habit in
                        
                        HStack {
                            Text("\(habit.habitName ?? "No Name")")
                                .swipeActions {
                                    Button {
                                        print("Check")
                                        
                                      
                                            habit.habitCheckAmount += 1
                                            StorageProvider.shared.save()
                                        // NOTE: Revisit, not effichent
                                            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()

                                        
                                        
                                    } label: {
                                        Label("Check", systemImage: "checkmark.circle")
                                    }
                                    .tint(.green)
                                }
                                Spacer()
                            Text("\(habit.habitCheckAmount) / \(habit.habitRepeatAmount)")
                        }
                    }
                
            }
            .toolbar {
                ToolbarAddHabitButton()
            }
            .onAppear {
                viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
            }
        }
    }
}
