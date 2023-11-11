//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

enum HomeViewType {
    case habitView,
         newPassivHabitView,
         editPassivHabitView,
         newActiveHabitView,
         editActiveHabitView
}

struct HomeView: View {

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
                    HomeHabitView(cards: $viewModel.cards, selectedHabit: $viewModel.selectedHabit, changeView: $viewModel.changeView)
                case .newPassivHabitView:
                    HomeEditView(changeView: $viewModel.changeView)
                case .editPassivHabitView:
                    DetailAndEditView(selectedHabit: $viewModel.selectedHabit, editing: $viewModel.detailEditing)
                case .newActiveHabitView:
                    EmptyView()
                case .editActiveHabitView:
                    EmptyView()
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
