//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    
    private var cards = ["Smoking", "Alcohole", "VideoGames", "Fats Food", "" , "" ]
    
    @State private var showEditSheet = false
    @State private var cardName = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
           
       ]
    
    var body: some View {
        
        
        NavigationView {
    
            VStack{
               
               
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(cards, id: \.self) { item in
                        Card(name: item)
                            .onTapGesture {
                                //Runs wehn given card is clicked
                                showEditSheet.toggle()
                                cardName = item
                            }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
                
            }
        .sheet(isPresented: $showEditSheet) {
            Text(cardName)
        }
           
            
            
            
        }
        
        
        
        
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
