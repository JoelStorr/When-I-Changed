//
//  PassivEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct PassivEditView: View {
    
    @State var nameField: String = ""
    @Binding var changeView: PassivViewType
    
    var body: some View {
        
     
            VStack{
                TextField("New Habit name", text: $nameField)
                Button("Save") {
                    //Run save function
                    StorageProvider.shared.savePassiveHabit(name: nameField)
                    changeView = .habitView
                    
                }
            }
            .navigationTitle("Edit")
            
        
        
    }
}


