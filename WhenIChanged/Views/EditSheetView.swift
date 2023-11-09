//
//  EditSheetView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct EditSheetView: View {
    
    
    @Binding var  isPresented : Bool
    @Binding var editItem: PassivHabit
    @State private var name = ""
    


    var body: some View {
        VStack{
            Form{
                TextField(editItem.habitName, text: $name)
                Button("Done"){
                    
                    if name.isEmpty {
                        isPresented = false
                        return
                    }
                    editItem.habitName = name
                    
                    isPresented = false
                    
                    StorageProvider.shared.save()
                }
            }
        }
    }
}


