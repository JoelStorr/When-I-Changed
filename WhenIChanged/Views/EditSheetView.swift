//
//  EditSheetView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct EditSheetView: View {
    
    
    @Binding var  isPresented : Bool
    @Binding var editIem: HabbitData
    @State private var name = ""
    
    var saveFunc : ()->()
    
    
    
    
    var body: some View {
        VStack{
            Form{
                TextField(editIem.habbitName, text: $name)
                Button("Done"){
                    
                    editIem.habbitName = name
                    
                    isPresented = false
                    
                    saveFunc()
                }
            }
        }
    }
}


