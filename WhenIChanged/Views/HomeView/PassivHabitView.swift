//
//  PassivHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

enum PassivViewType {
    case habitView,
         newPassivHabitView,
         editPassivHabitView
}

struct PassivHabitView: View {

    @StateObject var viewModel: ViewModel

    init(){
        let viewModel = ViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        NavigationView {
            VStack{
                switch viewModel.changeView {
                case .habitView:
                    HomePassivHabitView(cards: $viewModel.cards, selectedHabit: $viewModel.selectedHabit, changeView: $viewModel.changeView)
                case .newPassivHabitView:
                    PassivEditView(changeView: $viewModel.changeView)
                case .editPassivHabitView:
                    PassivDetailAndEditView(selectedHabit: $viewModel.selectedHabit, editing: $viewModel.detailEditing)
                }
            }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if viewModel.changeView != .habitView {
                        ToolbarItem(placement: .topBarLeading) {
                            HomeViewToolbarButtonLeading(changeView: $viewModel.changeView)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HomeViewToolbarButtonTrailing(changeView: $viewModel.changeView, detailEditing: $viewModel.detailEditing)
                    }
                }
                .onAppear{
                    viewModel.loadPassivHabits()
                }
                .onChange(of: viewModel.changeView){_ in
                    viewModel.loadPassivHabits()
                }
        }
    }
}
