//
//  ContentView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI


enum Views{
    case home, calander, settings
}


struct ContentView: View {
    
    @State private var showScreen : Views = Views.home
    
    var body: some View {
        TabView{
            PassivHabitView()
                .tabItem {
                    Label("Auto Habit", systemImage: "clock.arrow.2.circlepath")
                }
            PassivHabitView()
                .tabItem {
                    Label("Habit", systemImage: "checklist.checked")
                }
            CalendarView()
                .tabItem {
                    Label("Calander", systemImage: "calendar")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
