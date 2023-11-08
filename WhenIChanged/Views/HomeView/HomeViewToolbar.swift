//
//  HomeViewToolbar.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeViewToolbar: View {
    var body: some View {
        Menu {
            Button("Add Passiv Habit"){}
            Button("Add Active Habit"){}
        } label: {
            Label("Add", systemImage: "plus.circle")
        }
    }
}

#Preview {
    HomeViewToolbar()
}
