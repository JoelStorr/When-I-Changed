//
//  SpecialDayColorView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI
import PhotosUI

struct SpecialDayColorView: View {
    
    
    @Binding var selectedColor: String
    
    
    @State var avatarItem: PhotosPickerItem?
    @Binding var image : Image?
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        
        // TODO: Add image upload
        HStack{
            
            
            
            PhotosPicker("Select Background", selection: $avatarItem, matching: .images)
            
            
            LazyVGrid(columns: columns) {
                ForEach(CardColor.allCases, id: \.self){cardColor in
                    
                    if selectedColor == cardColor.rawValue && image == nil {
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
                                image = nil
                                selectedColor = cardColor.rawValue
                            }
                    }
                }
                
            }
        }
        .padding(.horizontal)
        .onChange(of: avatarItem) { newItem in
            
            Task{
                if let loaded = try? await newItem?.loadTransferable(type: Image.self) {
                    image = loaded
                } else {
                    print("Failed to load image")
                }
            }
            
        }
        
    }
}


