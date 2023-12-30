//
//  SpecialDay-CoreDataHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 28.12.23.
//

import Foundation


extension SpecialDay {
    
    var specialDayID: String {
        get {id?.uuidString ?? "" }
    }
    
    var specialDayName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    var specialDayColor: String {
        get { color ?? "red"}
        set { color = newValue }
    }
    
    var specialDayDate: Date {
        get { date ?? .now }
        set { date = newValue }
    }
    
    var specialDayDateToggle: Bool {
        get { dateToggle }
        set { dateToggle = newValue }
    }
    
    var specialDayFont: String {
        get { font ?? "SF Pro" }
        set { font = newValue }
    }
    
    var specialDayImage: Data {
        get { image ?? Data() }
        set { image = newValue }
    }
    
    var specialDayPosition: Int {
        get { Int(position) }
        set { position = Int16(newValue) }
    }
    
    var specialDayRepeatNextYear: Bool {
        get { repeatNextYear }
        set { repeatNextYear = newValue }
    }
    
    var specialDayWidgetSize: String {
        get { widgetSize ?? "smal" }
        set { widgetSize = newValue }
    }
}
