//
//  SpecialDayNameView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI

struct SpecialDayNameView: View {
    
    
    @Binding var name : String
    @Binding var date : Date
    
    var body: some View {
        List{
            TextField("Event name", text: $name)
            DatePicker("Special Date", selection: $date, displayedComponents: [.date])
            
        }
        
    }
}


