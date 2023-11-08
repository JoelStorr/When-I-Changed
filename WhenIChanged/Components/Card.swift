//
//  Card.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct Card: View {
    
    var name : String
    var time : String
    var startedString : String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(name)
                .font(.title2)
                .fontWeight(.bold)
            Text(time)
                .fontWeight(.bold)
            
            Text("Started: \(startedString)")
                .font(.caption)
        }
        .frame(width: 175, height: 100)
        .background(Color.orange)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .foregroundColor(.white)
        
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(name: "demo", time: " 5.0", startedString: "Jan 05 2020")
    }
}
