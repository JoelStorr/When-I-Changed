//
//  ActiveHabitOrderView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 19.12.23.
//

import SwiftUI

struct ActiveHabitOrderView: View {
    
    @State private var editMode = EditMode.inactive
    
    @Binding var habitArray: [ActiveHabit]
    
    var body: some View {
        List {
            ForEach(habitArray, id: \.id){ habit in
                Text(habit.habitName)
                
            }
            .onMove(perform: { indexSet, index in
                self.habitArray.move(fromOffsets: indexSet, toOffset: index)
            })
        }
        .navigationTitle("Change Order")
        .toolbar {
            EditButton()
        }
        .environment(\.editMode, $editMode)
        .onChange(of: editMode) { newValue in
            if newValue == .active {
                print("Activated edit View")
            }
            
            if newValue == .inactive {
                print("Deactivated edit view")
                
                for habit in habitArray {
                    print(habit.habitName)
                }
                
                // TODO: Run the save function for rearenging the array order
                StorageProvider.shared.updateActiveHabitOrder(habits: habitArray)
            }
        }
    }
}


