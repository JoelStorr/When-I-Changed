//
//  DetailAndEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct DetailAndEditView: View {
    @Binding var selectedHabit: PassivHabit
    @State private var name = ""
    
    @Binding var editing: Bool
    
    var body: some View {
        
        if editing {
            VStack{
                Form{
                    TextField(selectedHabit.habitName, text: $name)
                    Button("Done"){
                        
                        if name.isEmpty {
                           
                            return
                        }
                        selectedHabit.habitName = name
                        
                        StorageProvider.shared.save()
                    }
                }
            }
        } else {
            Text("Detail View")
        }
    }
}
