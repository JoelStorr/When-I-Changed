//
//  HomeViewToolbar.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeViewToolbarButtonTrailing: View {
    
    @Binding var changeView: HomeViewType
    @Binding var detailEditing: Bool
    
    var body: some View {
        if changeView == .habitView {
            Menu {
                Button("Add Passiv Habit"){changeView = .newPassivHabitView}
                Button("Add Active Habit"){changeView = .newActiveHabitView}
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
        } else if changeView == .editPassivHabitView {
            
            if detailEditing {
                Button("Cancle"){
                    detailEditing.toggle()
                }
            } else {
                Button{
                    detailEditing.toggle()
                } label: {
                    Label("Edit", systemImage: "ellipsis.circle")
                }
            }
            
            
            
        } else {
            Button("Cancle"){
                changeView = .habitView
            }
        }
    }
}
