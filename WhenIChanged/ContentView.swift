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
            HomeView()
               
                .tabItem {
                    Label("Home", systemImage: "house.fill")
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
