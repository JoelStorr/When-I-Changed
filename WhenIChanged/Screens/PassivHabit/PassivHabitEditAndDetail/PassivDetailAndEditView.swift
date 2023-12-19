//
//  PassivDetailAndEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct PassivDetailAndEditView: View {

    @ObservedObject var viewModel: ViewModel

    init(selectedHabit: PassivHabit) {
        self.viewModel = ViewModel(selectedHabit: selectedHabit)
    }

    var body: some View {
        VStack {
            if viewModel.editing {
                Form {
                    TextField(viewModel.selectedHabit.habitName, text: $viewModel.name)
                    HStack {
                        Button("Select Color") {
                            viewModel.showColorSheet.toggle()
                        }
                        Spacer()
                            .frame(minWidth: 20)
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(
                                viewModel.selectedColor == nil
                                ?  cardColorConverter(color: viewModel.selectedHabit.habitColor)
                                : cardColorConverter(color: viewModel.selectedColor!)
                            )
                    }
                    Button("Done") {
                        if !viewModel.name.isEmpty {
                            viewModel.selectedHabit.habitName = viewModel.name
                        }

                        if viewModel.selectedColor != nil {
                            viewModel.selectedHabit.habitColor = viewModel.selectedColor!
                        }
                        let _ = StorageProvider.shared.save()
                        viewModel.editing.toggle()
                        // changeView = .editPassivHabitView
                    }
                }
            } else {
                Spacer()
                    .frame(height: 20)
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(cardColorConverter(color: viewModel.selectedHabit.habitColor))
                        .frame(maxHeight: 150)
                    VStack(spacing: 20) {
                        HStack {
                            Text(viewModel.selectedHabit.habitName)
                                .font(.system(size: 25, weight: .black))
                            Spacer()
                        }
                        Text(viewModel.timeString)
                            .font(.system(size: 30, weight: .black))
                            .fontWeight(.bold)
                        HStack {
                            Spacer()
                            Text("Started at \(viewModel.selectedHabit.startDateString)")
                        }
                    }
                    .padding()
                }
                .padding([.leading, .trailing])
                Button {
                    StorageProvider.shared.resetCurrentHabitStreak(viewModel.selectedHabit)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.red.opacity(0.9))
                            .frame( height: 50)
                        Label("Reset", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                .padding([.leading, .trailing])
                List {
                    NavigationLink {
                        PastResetsView(habitResetDatest: viewModel.selectedHabit.habitResetDates)
                    } label: { Text("Show All Resets") }
                    // swiftlint:disable:next todo
                    // TODO: Add Rewards View & Logic
                    NavigationLink {} label: { Text("Show Rewards") }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(cardColorConverter(color: viewModel.selectedHabit.habitColor).opacity(0.5))
                        .frame(maxHeight: 150)
                    VStack {
                        HStack {
                            Text("States")
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Text("""
                                    \(
                                        viewModel.selectedHabit.habitResetDates.count > 0
                                        ? viewModel.selectedHabit.habitResetDates.count - 1
                                        : 0
                                    )
                                """)
                                Text("Resets")
                            }
                            Spacer()
                            VStack {
                                Text("\(viewModel.selectedHabit.calculateLongestStreak()) days")
                                Text("Longest Streak")
                            }
                        }
                        HStack {
                            VStack {
                                Text("\(viewModel.selectedHabit.timeSinceStart())")
                                Text("Since Started")
                            }
                            Spacer()
                            VStack {
                                Text("\(viewModel.selectedHabit.calculateAvaregStreakLength()) days")
                                Text("Avarage Streak")
                            }
                        }
                    }.padding()
                }
            }
        }
        .navigationTitle(viewModel.editing ? "Edit" : "Detail")
        .onAppear(perform: viewModel.timeManager)
        .sheet(isPresented: $viewModel.showColorSheet) {
            VStack {
                HStack {
                    Spacer()
                    Button("Cancle") {
                        viewModel.showColorSheet.toggle()
                    }.padding()
                }
                List {
                    ForEach(CardColor.allCases, id: \.rawValue) {color in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(cardColorConverter(color: color.rawValue))
                            .onTapGesture {
                                viewModel.showColorSheet.toggle()
                                viewModel.selectedColor = color.rawValue
                            }
                    }
                }
            }
        }
        .toolbar {
            if viewModel.editing {
                Button("Cancle") {
                    viewModel.editing.toggle()
                }
            } else {
                Button {
                    viewModel.editing.toggle()
                } label: {
                    Label("Edit", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}
