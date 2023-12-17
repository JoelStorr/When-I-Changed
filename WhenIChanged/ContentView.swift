//
//  ContentView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI
import NotificationCenter

enum Views {
    case passivHabit, activeHabit, calander, settings
}

struct ContentView: View {
    @State private var showScreen: Views = Views.activeHabit
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        TabView(selection: $showScreen) {
            PassivHabitView()
                .tabItem {
                    Label("Auto Habit", systemImage: "clock.arrow.2.circlepath")
                }
                .tag(Views.passivHabit)

            ActiveHabitView()
                .tabItem {
                    Label("Active Habit", systemImage: "checklist.checked")
                }
                .tag(Views.activeHabit)
            SpecialDayView()
                .tabItem {
                    Label("Special Day", systemImage: "calendar")
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
//            userNotificationCenter.setBadgeCount(0)
//            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
}
