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
            
            
            VStack{
                ZStack {
                    PhotosPicker("        ", selection: $avatarItem, matching: .images)
                    VStack{
                        Image(systemName: "photo.on.rectangle.angled")
                        Text(image == nil ? "Add Image": "Change Image")
                    }
                    
                }
                Spacer()
                    .frame(height: 20)
                if image != nil {
                    Button{
                        image = nil
                    } label: {Text("Remove")}
                }                
            }
            
            
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


