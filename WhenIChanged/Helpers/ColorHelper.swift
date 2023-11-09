//
//  ColorHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import SwiftUI


enum CardColor:String {
    case red, green, blue
}


func cardColorConverter(color: CardColor) -> Color{
    switch color {
    case .red:
        return Color.red
    case .green:
        return Color.green
    case .blue:
        return Color.blue
    }
}
