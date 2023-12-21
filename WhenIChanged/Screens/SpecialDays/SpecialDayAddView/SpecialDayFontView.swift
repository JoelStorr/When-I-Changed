//
//  SpecialDayFontView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI

struct SpecialDayFontView: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @Binding var selectedFont: String
    
    let fonts = ["SF Pro","AmericanTypewriter", "ArialMT","Baskerville", "Chalkboard SE", "Chalkduster", "Didot", "Futura", "Georgia", "Hoefler Text", "Marker Felt", "Menlo", "Symbol", "Times New Roman" ]
    
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns) {
                ForEach(fonts, id: \.self) { font in
                    Text("Demo Text")
                        .font(.custom(font, size: 25.0))
                        .foregroundStyle(selectedFont == font ? Color.blue : Color.primary)
                        .padding()
                        .onTapGesture{
                            selectedFont = font
                        }
                }
            }
        }
    }
}
