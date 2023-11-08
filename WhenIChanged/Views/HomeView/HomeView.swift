//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    @State var cards = [HabitData(habbitName: "Smoking") ]
    @State var showEditView = false
    @State var addingHabit: Bool = false
    @State var addingAutoHabit: Bool = true
    
    var body: some View {
        
        
        NavigationView {
            VStack{
                
                if showEditView {
                    HomeEditView(saveFunc: saveNewHabit)
                } else {
                    HomeHabitView(cards: $cards)
                }
                
            }
                .padding()
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HomeViewToolbar(showEditSheet: $showEditView)
                }
        }
    }
    
    func saveNewHabit(name:String) -> Void{
        let habit = HabitData(habbitName: name)
        cards.append(habit)
        showEditView.toggle()
    }
    
}
