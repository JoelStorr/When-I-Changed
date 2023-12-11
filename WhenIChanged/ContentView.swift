//
//  ContentView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

enum Views {
    case passivHabit, activeHabit, calander, settings
}

struct ContentView: View {
    @State private var showScreen: Views = Views.activeHabit
    
    var body: some View {
        TabView(selection: $showScreen) {
            HomePassivHabitView()
                .tabItem {
                    Label("Auto Habit", systemImage: "clock.arrow.2.circlepath")
                }
                .tag(Views.passivHabit)

            ActiveHabitView()
                .tabItem {
                    Label("Habit", systemImage: "checklist.checked")
                }
                .tag(Views.activeHabit)
            CalendarView( habitColor: Color.green)
                .tabItem {
                    Label("Calander", systemImage: "calendar")
                }
                .tag(Views.calander)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Views.settings)
        }
        .onAppear {
            StorageProvider.shared.loadSettings()
        }
        
    }
}
