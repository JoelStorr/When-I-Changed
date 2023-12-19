//
//  ActiveHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 12.11.23.
//

import SwiftUI

struct ActiveHabitView: View {

    @StateObject var viewModel: ViewModel = ViewModel()
    
    @GestureState var press = false
    @State var goToDetail = false
    @State var goToChangeOder = false
    @State var path: [ActiveHabit] = []

    var body: some View {

        NavigationStack(path: $path) {
                List {
                    ForEach($viewModel.activeHabits, id: \.id) { $habit in
                        ZStack {
//                            NavigationLink(destination: ActiveHabitDetailView(habit: habit)) { }.opacity(0.0)
                            HStack {
                                Text("\(habit.habitName.count != 0 ? habit.habitName : "No Name")")
                                    .fontWeight(.bold)
                                    .foregroundStyle(cardColorConverter(color: habit.habitColor))
                                    .swipeActions {
                                        Button {
                                            StorageProvider.shared.addCheckToActiveHabit(habit)
                                            // NOTE: Revisit, not effichent
                                            viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
                                        } label: {
                                            Text("+1")
                                        }
                                        .tint(.green)
                                        Button {
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
                                VStack {
                                    Text("\(habit.habitCheckAmount) / \(habit.habitRepeatAmount)")
                                        .foregroundStyle(cardColorConverter(color: habit.habitColor))
                                        .fontWeight(.bold)
                                    Text("per \(habit.habitRepeatInterval)")
                                        .foregroundStyle(cardColorConverter(color: habit.habitColor))
                                        .font(.caption)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.001))
                        .onTapGesture {
                            path.append(habit)
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            path.append(habit)
                            goToChangeOder.toggle()
                        }
                        
//                        .onLongPressGesture(minimumDuration: 0.5) {
//                            NavigationLink(destination: ActiveHabitOrderView()) { }
//                        }
                        
                        
//                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
//                        .listRowSeparator(.hidden)
                    }
            }
                .navigationDestination(for: ActiveHabit.self){ value in
                        
                        
                    if goToChangeOder {
                        
                        ActiveHabitOrderView()
                    } else {
                        ActiveHabitDetailView(habit: value)
                    }
                    
                }
                .navigationTitle("Active Habit")
            .listStyle(DefaultListStyle())
            .toolbar {
                ToolbarAddHabitButton()
            }
            .onAppear {
                viewModel.activeHabits = StorageProvider.shared.loadAllActiveHabits()
                goToChangeOder = false
            }
        }
    }
}
