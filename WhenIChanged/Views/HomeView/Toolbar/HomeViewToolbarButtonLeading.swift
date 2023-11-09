//
//  HomeViewToolbarButtonLeading.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import SwiftUI

struct HomeViewToolbarButtonLeading: View {
    
    @Binding var changeView: HomeViewType
    
    
    var body: some View {
        Button {
            changeView = .habitView
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
        }
    }
}

