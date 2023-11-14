//
//  ActiveHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 12.11.23.
//

import SwiftUI

struct ActiveHabitView: View {
    var body: some View {
        
        NavigationStack {
            NavigationLink {ActiveHabitAddView()} label: {
                Text("Press me to add new Element")
            }
            .toolbar {
                ToolbarAddHabitButton()
            }
        }
    }
}

