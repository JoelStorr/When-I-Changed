//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(){
        let viewModel = ViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        
        NavigationView {
            VStack{
                
                if viewModel.showEditView {
                    HomeEditView(saveFunc: viewModel.saveNewHabit)
                } else {
                    HomeHabitView(cards: $viewModel.cards)
                }
                
            }
                .padding()
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HomeViewToolbar(showEditSheet: $viewModel.showEditView)
                }
        }
    }
    
    
    
}
