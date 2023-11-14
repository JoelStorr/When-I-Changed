//
//  AddActiveHabit.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.11.23.
//

import SwiftUI

enum UnitTypes: String {
    case numberOfTimes, duration, weight
}

enum RepeatType: String, CaseIterable {
    case Daily, Weekly, Monthly, Custom
}



struct ActiveHabitAddView: View {
    
    @State var name: String = ""
    @State var selectedColor: ActiveHabitColor = ActiveHabitColor.green
    @State var reminder: Date = .now
    @State var repeatInterval: String? = nil
    @State var time: Date? = nil
    @State var unit: UnitTypes? = nil
    
    @State var showColorSheet: Bool = false
    @State var useReminder: Bool = false

    @State var selectedType: Int = 0
    
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.secondarySystemFill
    }
    
    var body: some View {
        Form{
            TextField("Name", text: $name)
            Button {showColorSheet.toggle()} label: {
                HStack {
                    Text("Color")
                    Spacer()
                        .frame(minWidth: 20)
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(cardColorConverter(color: selectedColor.rawValue))
                }
            }
            
            Section("Repeat") {
                Picker(selection: $selectedType, label: Text("How often do you want to be reminded")){
                    ForEach(0..<RepeatType.allCases.count, id: \.self) { (index) in
                        Text("\(RepeatType.allCases[index].rawValue)").tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section("Reminder") {
                Toggle(isOn: $useReminder, label: {
                    Text("Want to get reminded?")
                })
                if useReminder {
                    DatePicker("Select Reminder", selection: $reminder)
                }
            }
            
            
            Button("Save") {
                StorageProvider.shared.saveActiveHabit(name: name, color: selectedColor, reminder: reminder, repeatInterval: repeatInterval, time: time, unit: unit?.rawValue)
            }
        }
        .sheet(isPresented: $showColorSheet) {
            VStack{
                HStack{
                    Spacer()
                    Button("Cancle") {
                        showColorSheet.toggle()
                    }.padding()
                }
                List {
                    ForEach(ActiveHabitColor.allCases, id: \.rawValue) {color in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(cardColorConverter(color: color.rawValue))
                            .onTapGesture {
                                showColorSheet.toggle()
                                selectedColor = color
                            }
                    }
                }
            }
        }
    }
}

