//
//  HomeHabitView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct HomeHabitView: View {
    
    
    @State var cards = [HabbitData(habbitName: "Smoking") ]
    @State private var editCard : HabbitData = HabbitData(habbitName: "")
    @State var isPresented : Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
           
       ]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(cards, id: \.id) { item in
                    Card(name: item.habbitName, time: item.timeSpan())
                        .onTapGesture {
                            //Runs wehn given card is clicked
                            editCard = item
                            isPresented.toggle()
                        }
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresented) {
            EditSheetView(isPresented: $isPresented, editItem: $editCard, saveFunc: saveCardItem)
        }
    }
    
    
    //NOTE: Change saving funcvtion when data is saved
     func saveCardItem() -> Void {
        
        for index in 0..<cards.count {
            if cards[index].id == editCard.id {
                cards[index] = editCard
            }
        }
        
        
        
    }
}
 

