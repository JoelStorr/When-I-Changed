//
//  HomePassivHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct PassivHabitView: View {

    @StateObject var viewModel: ViewModel = ViewModel()
    
    @State var path: [PassivHabit] = []
    @State var goToChangeOder = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
       ]

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.cards, id: \.id) { item in

                        Card(habit: item)
                            .onTapGesture {
                                path.append(item)
                            }
                            .onLongPressGesture(minimumDuration: 0.5) {
                                path.append(item)
                                goToChangeOder.toggle()
                            }
                    }
                }
                Spacer()
            }
            .navigationTitle("Passiv Habit")
            .navigationDestination(for: PassivHabit.self){ value in
                if goToChangeOder {
                    PassivHabitOrderView(habitArray: $viewModel.cards)
                } else {
                    PassivDetailAndEditView(selectedHabit: value)
                }
            }
            .onAppear {
                viewModel.loadPassivHabits()
            }
            .toolbar {
               ToolbarAddHabitButton()
            }
        }
    }
}
