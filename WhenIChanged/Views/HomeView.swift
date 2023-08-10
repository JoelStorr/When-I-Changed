//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    
    @State private var cards = [HabbitData(habbitName: "Smoking"), ]
    
    @State private var showEditSheet = false
    @State private var editCard : HabbitData = HabbitData(habbitName: "")
    @State var isPresented : Bool = false
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
           
       ]
    
    var body: some View {
        
        
        NavigationView {
    
            VStack{
               
               
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(cards, id: \.self) { item in
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
            .padding()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
                
            }
            .sheet(isPresented: $isPresented) {
                EditSheetView(isPresented: $isPresented, editIem: $editCard, saveFunc: saveCardItem)
            }
        
           
            
            
            
        }
        
       
    //NOTE: Change saving funcvtion when data is saved
     func saveCardItem() -> Void {
        
        for index in 0..<cards.count {
            if self.cards[index].id == self.editCard.id {
                self.cards[index] = self.editCard
            }
        }
        
        
        
    }
    
    
        
        
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
