//
//  HomeViewToolbar.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeViewToolbar: View {
    
    @Binding var changeView: HomeViewType
    
    var body: some View {
        if changeView == .habitView {
            Menu {
                Button("Add Passiv Habit"){changeView = .newPassivHabitView}
                Button("Add Active Habit"){changeView = .newActiveHabitView}
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
        } else {
            Button("Cancle"){
                changeView = .habitView
            }
        }
    }
}
