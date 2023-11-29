//
//  HomePassivHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomePassivHabitView: View {

    @StateObject var viewModel: ViewModel = ViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
       ]

    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.cards, id: \.id) { item in

                        NavigationLink {
                            PassivDetailAndEditView(selectedHabit: item)
                        } label: {
                            Card(habit: item)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Home")
            .onAppear {
                viewModel.loadPassivHabits()
            }
            .toolbar {
               ToolbarAddHabitButton()
            }
        }
    }
}
