//
//  PassivHabitAddView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct PassivHabitAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var nameField: String = ""
    
    var body: some View {
            Form{
                TextField("New Habit name", text: $nameField)
                Button("Save") {
                    //Run save function
                    StorageProvider.shared.savePassiveHabit(name: nameField)
                   dismiss()
                    
                }
            }
            .navigationTitle("Edit")
    }
}