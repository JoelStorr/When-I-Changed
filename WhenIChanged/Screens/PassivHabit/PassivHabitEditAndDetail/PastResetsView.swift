//
//  PastResetsView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.11.23.
//

import SwiftUI

struct PastResetsView: View {
    
    
    var habitResetDatest: [PastResets]
    
    
    var body: some View {
        List {
            ForEach( habitResetDatest, id: \.self ) { reset in
                Text("\(reset.wrappedResetDate)")
            }
        }
        .navigationTitle("Past Resets")
    }
}


