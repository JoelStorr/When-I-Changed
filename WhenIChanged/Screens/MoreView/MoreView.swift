//
//  SettingsView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        
        NavigationStack {
            List{
                NavigationLink{SettingsView()}label: {
                    Text("Settings")
                }
                NavigationLink{StatisticsView()}label: {
                    Text("Statistics")
                }
            }
            .navigationTitle("More")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
