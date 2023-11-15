//
//  View+Ext.swift
//  WhenIChanged
//
//  Created by Joel Storr on 15.11.23.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension View {
    
    
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
    
    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
    
    
    func isFirstField<F: RawRepresentable> (_ field: FocusState<F?>.Binding) -> Bool where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return false }
        
        if currentValue.rawValue - 1  < 0 {
            return true
        } else {
            return false
        }
    }
    
    func isLastField<F: RawRepresentable> (_ field: FocusState<F?>.Binding, enumLength: Int) -> Bool where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return false }
        
        if currentValue.rawValue + 1  >= enumLength {
            
            return true
        } else {
            return false
        }
    }
}
