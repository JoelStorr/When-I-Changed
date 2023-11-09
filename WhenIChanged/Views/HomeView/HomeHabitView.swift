//
//  HomeHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeHabitView: View {
    
    
    @Binding var cards: [PassivHabit]
    @Binding var selectedHabit: PassivHabit
    @Binding var changeView: HomeViewType
   
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
       ]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(cards, id: \.id) { item in
                    Card(habit: item)
                        .onTapGesture {
                            //Runs wehn given card is clicked
                            selectedHabit = item
                            changeView = .editPassivHabitView
                        }
                }
            }
            Spacer()
        }
        .navigationTitle("Home")
    }
}
 

