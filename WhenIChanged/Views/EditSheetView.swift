//
//  EditSheetView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct EditSheetView: View {
    
    
    @Binding var  isPresented : Bool
    @Binding var editItem: HabitData
    @State private var name = ""
    
    var saveFunc : ()->()

    var body: some View {
        VStack{
            Form{
                TextField(editItem.habbitName, text: $name)
                Button("Done"){
                    
                    if name.isEmpty {
                        isPresented = false
                        return
                    }
                    editItem.habbitName = name
                    
                    isPresented = false
                    
                    saveFunc()
                }
            }
        }
    }
}


