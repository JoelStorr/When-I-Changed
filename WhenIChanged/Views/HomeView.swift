//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    
    private var cards = ["Smoking", "Alcohole", "VideoGames", "Fats Food", "" , "" ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
           
       ]
    
    var body: some View {
        
        
        NavigationView {
    
            VStack{
               
               
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cards, id: \.self) { item in
                        Card(name: item)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
                
                
                
                
            
            }
           
            
            
            
        }
        
        
        
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
