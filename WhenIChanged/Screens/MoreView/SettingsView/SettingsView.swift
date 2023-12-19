//
//  SettingsView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 19.12.23.
//

import SwiftUI

struct SettingsView: View {
    
    @State var weekStartsMonday: Bool = true
    
    var body: some View {
        List{
            Section(){
                Toggle("Week start is Monday", isOn: $weekStartsMonday)
            }
            
            Button("Save") {
                StorageProvider.shared.globalSetupClass.weekStartsMonday = weekStartsMonday
                let _ = StorageProvider.shared.save()
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            weekStartsMonday = StorageProvider.shared.globalSetupClass.weekStartsMonday
        }
        
    }
}

#Preview {
    SettingsView()
}
