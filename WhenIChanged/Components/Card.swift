//
//  Card.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct Card: View {
    
    var name : String = "Demo Name"
    var time : String = "250  days"
    var started : String = "Statred ad Jan 05 2020"
    
    var body: some View {
        VStack(alignment: .leading){
            Text(name)
                .font(.largeTitle)
            
            Text(time)
                .font(.title2)
            
            Text(started)
                .font(.caption)
                
            
            
        }
        .frame(width: 200, height: 150)
        .background(Color.orange)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card()
    }
}
