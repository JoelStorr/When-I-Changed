//
//  ColorHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import SwiftUI

enum CardColor: String, CaseIterable {
    case red, green, blue
}

enum ActiveHabitColor: String, CaseIterable {
    case red, green, blue, yellow, purple
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



