//
//  ToolBarAddHabitButton.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.11.23.
//

import SwiftUI

struct ToolbarAddHabitButton: View {
    var body: some View {
        Menu {
            NavigationLink { PassivHabitAddView() } label: { Text("Add Passiv Habit") }
            NavigationLink { ActiveHabitAddView() } label: { Text("Add Active Habit") }

        } label: {
            Label("Add", systemImage: "plus.circle")
        }
    }
}
