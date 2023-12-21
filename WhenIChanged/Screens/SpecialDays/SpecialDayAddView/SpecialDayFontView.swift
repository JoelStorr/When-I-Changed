//
//  SpecialDayFontView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI

struct SpecialDayFontView: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    let fonts = ["AmericanTypewriter", "ArialMT","Baskerville", "Chalkboard SE", "Chalkduster", "Didot", "Futura", "Georgia", "Hoefler Text", "Marker Felt", "Menlo", "Symbol", "Times New Roman" ]
    
    
    var body: some View {
        
        LazyVGrid(columns: columns) {
            
            
            ForEach(fonts, id: \.self) { font in
                
                Text("Demo Text")
                    .font(.custom(font, size: 20.0))
                
            }
            
        }
        
    }
}

#Preview {
    SpecialDayFontView()
}
