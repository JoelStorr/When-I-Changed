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
                    HomeHabitView(cards: $viewModel.cards)
                case .newPassivHabitView:
                    HomeEditView(saveFunc: viewModel.saveNewHabit)
                case .editPassivHabitView:
                    EmptyView()
                case .newActiveHabitView:
                    HomeEditView(saveFunc: viewModel.saveNewHabit)
                case .editActiveHabitView:
                    EmptyView()
                }
            }
                .padding()
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HomeViewToolbar(changeView: $viewModel.changeView)
                }
        }
    }
    
    
    
}
