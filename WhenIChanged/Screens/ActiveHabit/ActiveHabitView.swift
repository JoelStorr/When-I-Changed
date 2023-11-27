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
                       
                        
                        ZStack {
                            
                            NavigationLink(destination: ActiveHabitDetailView()) { }.opacity(0.0)
                            
                            HStack {
                                Text("\(habit.habitName ?? "No Name")")
                                    .fontWeight(.bold)
                                    .foregroundStyle(cardColorConverter(color: habit.habitColor))
                                    .swipeActions {
                                        Button {
                                            print("Check")
                                            
                                            
                                            StorageProvider.shared.addCheckToActiveHabit(habit)
                                            // NOTE: Revisit, not effichent
                                            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
                                            
                                            
                                            
                                        } label: {
                                            Text("+1")
                                                
                                        }
                                        .tint(.green)
                                        
                                        
                                        Button {
                                            print("Check")
                                            StorageProvider.shared.completeCheckToActiveHabit(habit)
                                            // NOTE: Revisit, not effichent
                                            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
                                        } label: {
                                            Text("Finish")
                                        }
                                        .tint(.orange)
                                    }
                                    
                                    
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            StorageProvider.shared.deleteActiveHabit(habit)
                                            // NOTE: Revisit, not effichent
                                            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
                                        } label: {
                                            Label("Delete", systemImage: "xmark.circle")
                                        }
                                        .tint(.red)
                                        
                                    }
                                Spacer()
                                Text("\(habit.habitCheckAmount) / \(habit.habitRepeatAmount)")
                                    .foregroundStyle(cardColorConverter(color: habit.habitColor))
                                    .fontWeight(.bold)
                            }
                        }
                        
                        .padding()
//                        .background(Color.green.opacity(0.4))
//                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
//                        .listRowSeparator(.hidden)
                        
                    }
                    
                    
                
            }
                .listStyle(DefaultListStyle())
               
                
            .toolbar {
                ToolbarAddHabitButton()
            }
            .onAppear {
                viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
            }
        }
    }
}
