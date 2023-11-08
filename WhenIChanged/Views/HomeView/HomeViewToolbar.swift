//
//  HomeViewToolbar.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeViewToolbar: View {
    
    @Binding var showEditSheet: Bool
    
    var body: some View {
        Menu {
            Button("Add Passiv Habit"){showEditSheet = true}
            Button("Add Active Habit"){showEditSheet = true}
        } label: {
            Label("Add", systemImage: "plus.circle")
        }
    }
}
