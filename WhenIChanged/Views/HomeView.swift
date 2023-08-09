//
//  HomeView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct HomeView: View {
    
    
    private var cards = ["Smoking", "Alcohole", "VideoGames", "Fats Food"]
    
    var body: some View {
        
        
        NavigationView {
    
            VStack{
                Spacer()
                List{
                    ForEach(cards, id: \.self){ card in
                        Text(card)
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
