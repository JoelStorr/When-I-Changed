//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showEditSheet = false
    @State var addingHabit: Bool = false
    @State var addingAutoHabit: Bool = true
    
    var body: some View {
        
        
        NavigationView {
            VStack{
                
                if showEditSheet {
                    EmptyView()
                } else {
                    HomeHabitView()                    
                }
                
            }
                .padding()
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HomeViewToolbar()
                }
        }
    }
}
