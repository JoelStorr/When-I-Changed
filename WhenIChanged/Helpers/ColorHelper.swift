//
//  ColorHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import SwiftUI

enum CardColor: String, CaseIterable {
    case red, green, blue, yellow, purple, teal, indigo, mint, orange
}

enum ActiveHabitColor: String, CaseIterable {
    case red, green, blue, yellow, purple, teal, indigo, mint, orange
}

func cardColorConverter(color: String) -> Color {
    switch color {
    case "red":
        return Color.red
    case "green":
        return Color.green
    case "blue":
        return Color.blue
    case "yellow":
        return Color.yellow
    case "purple":
        return Color.purple
    case "teal":
        return Color.teal
    case "indigo":
        return Color.indigo
    case "mint":
        return Color.mint
    case "orange":
        return Color.orange
        
    default:
        return Color.red
    }
}


func colorStringToEnum(colorString: String) -> ActiveHabitColor{
    switch colorString {
    case "red":
        return ActiveHabitColor.red
    case "green":
        return ActiveHabitColor.green
    case "blue":
        return ActiveHabitColor.blue
    case "yellow":
        return ActiveHabitColor.yellow
    case "purple":
        return ActiveHabitColor.purple
    default:
        return ActiveHabitColor.red
    }
}



