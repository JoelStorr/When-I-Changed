//
//  SpecialDayColorView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI

struct SpecialDayColorView: View {
    
    
    @Binding var selectedColor: String
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        
        // TODO: Add image upload
        
        LazyVGrid(columns: columns) {
            ForEach(CardColor.allCases, id: \.self){cardColor in
                
                if selectedColor == cardColor.rawValue {
                    ZStack {
                        Circle()
                            .stroke(cardColorConverter(color: cardColor.rawValue), lineWidth: 1.5)
                            .frame(maxWidth: 35)
                        
                        Circle()
                            .fill(cardColorConverter(color: cardColor.rawValue))
                            .frame(width: 30, height: 30)
                            .padding()
                            .onTapGesture {
                                selectedColor = cardColor.rawValue
                            }
                    }
                } else {
                    Circle()
                        .fill(cardColorConverter(color: cardColor.rawValue))
                        .frame(width: 30, height: 30)
                        .padding()
                        .onTapGesture {
                            selectedColor = cardColor.rawValue
                        }
                }
            }
            
        }
        .padding(.horizontal)
        
    }
}


