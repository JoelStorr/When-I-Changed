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
    case Day, Week, Month
}


enum Field: Int, CaseIterable {
    case name, repeatAmount
}

enum Days: String, CaseIterable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}


class ReminderData: ObservableObject {
    var id = UUID()
    @Published var day: Days =  Days.Monday
    @Published var time: Date = .now

}




struct ActiveHabitAddView: View {
    
    @State var name: String = "" // done
    @State var selectedColor: ActiveHabitColor = ActiveHabitColor.green // done
    @State var reminder: Date = .now // todo
    @State var repeatInterval: String? = nil // Add coresponding Date besed on selected interval
    @State var repeatAmount: String = "" // done
    @State var time: Date = .now        // todo
    @State var unit: UnitTypes? = nil   // todo
    @State var positiveHabit: Int = 0 // done
    
    @State var showColorSheet: Bool = false
    @State var useReminder: Bool = false

    @State var selectedType: Int = 0
    @State var selectedDay: Int = 0
    
    
    @State var addedReminders = [ReminderData]()
    
    @FocusState private var focusField: Field?
    
    
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.secondarySystemFill
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .focused($focusField, equals: .name)
                .onSubmit{ self.focusNextField($focusField) }
            Button {showColorSheet.toggle()} label: {
                HStack {
                    Text("Color")
                    Spacer()
                        .frame(minWidth: 20)
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(cardColorConverter(color: selectedColor.rawValue))
                }
            }
            
            Section("Positive or Negative Habit?") {
                Picker(selection: $positiveHabit, label: Text("Do you want to do more of this or less") ) {
                    Text("Positive Habit").tag(0)
                    Text("Negative Habit").tag(1)
                }.pickerStyle(.segmented)
            }
            
            Section("Repeat") {
                HStack {
                    TextField("1", text:$repeatAmount).keyboardType(.numberPad)
                        .focused($focusField, equals: .repeatAmount)
                        .onSubmit{ self.focusNextField($focusField) }
                        .frame(width: 50)
                    Text("/ per")
                    Spacer()
                    Picker(selection: $selectedType, label: Text("How often do you want to be reminded")){
                        ForEach(0..<RepeatType.allCases.count, id: \.self) { (index) in
                            Text("\(RepeatType.allCases[index].rawValue)").tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Section("Reminder") {
                Toggle(isOn: $useReminder, label: {
                    Text("Want to get reminded?")
                })
                if useReminder {
                    
                    if selectedType == 0 {
                        DatePicker("Select Reminder", selection: $time, displayedComponents: .hourAndMinute)
                    } else if selectedType == 1 {
                        
                       
                            Button("Add") {
                                self.addReminderToArray()
                            }
                        
                        
                        ForEach(0..<addedReminders.count, id: \.id) { index in
                            HStack {
                                Picker(selection: $addedReminders[index].day, label: Text("Select the day")) {
                                    ForEach(0..<Days.allCases.count, id: \.self) { index in
                                        Text("\(Days.allCases[index].rawValue)").tag(index)
                                    }
                                }
                                Spacer()
                                    .frame(width: 20)
                                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                    .frame(width: 50)
                            }
                                
                            
                        }
                        
                        
                    } else {
                        Text("Test")
                    }
                
                }
            }
            
            
            Button("Save") {
                print("Save")
                StorageProvider.shared.saveActiveHabit(
                    name: name,
                    color: selectedColor,
                    positiveHabit: positiveHabit == 0 ? true : false,
                    reminder: reminder,
                    repeatInterval: repeatInterval,
                    time: time,
                    unit: unit?.rawValue,
                    repeatAmount: Int(repeatAmount) ?? 1
                )
            }
        }
//        .onTapGesture {
//            self.hideKeyboard()
//        }
        .navigationTitle("Add Active Habit")
        .toolbar {
            
            ToolbarItemGroup(placement: .keyboard) {
                Button{self.focusPreviousField($focusField)} label: {
                    Image(systemName: "chevron.up")
                }.disabled(self.isFirstField($focusField))
                Button{self.focusNextField($focusField)} label: {
                    Image(systemName: "chevron.down")
                }
                .disabled(self.isLastField($focusField, enumLength: Field.allCases.count))
                Spacer()
               Button("Done"){
                  focusField = nil
               }
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
    
    
    func addReminderToArray(){
        print("Added Reminder Data")
        addedReminders.append(ReminderData(day: Days.Monday, time: .now))
    }
    
    
    
}
