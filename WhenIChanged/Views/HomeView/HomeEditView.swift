//
//  HomeEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeEditView: View {
    
    @State var nameField: String = ""
    let saveFunc : (_: String) -> Void
    
    var body: some View {
        
     
            VStack{
                TextField("New Habit name", text: $nameField)
                Button("Save") {
                    //Run save function
                    saveFunc(nameField)
                    
                }
            }
            
        
        
    }
}


