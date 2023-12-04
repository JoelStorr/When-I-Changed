//
//  RoundProgressBar.swift
//  WhenIChanged
//
//  Created by Joel Storr on 04.12.23.
//

import SwiftUI

struct RoundProgressBar: View {
    
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        
        
    }
}


#Preview {
    RoundProgressBar(progress: 0.4, color: Color.red)
}
