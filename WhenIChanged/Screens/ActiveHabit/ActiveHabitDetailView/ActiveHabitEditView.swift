//
//  ActiveHabitEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.12.23.
//

//
//  AddActiveHabit.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.11.23.
//

import SwiftUI


struct ActiveHabitEditView: View {
    
    let habit: ActiveHabit

    @Environment(\.dismiss) var dismiss
    
    
    
    

    @State var name: String = ""
    @State var selectedColor: ActiveHabitColor = ActiveHabitColor.green // done
//    @State var reminder: Date = .now // todo
    @State var repeatInterval: String? // Add coresponding Date besed on selected interval
    @State var repeatAmount: String = "" // done
    @State var time: Date = .now        // todo
//    @State var unit: UnitTypes?   // todo
    @State var positiveHabit: Int = 0 // done

    @State var showColorSheet: Bool = false
    @State var useReminder: Bool = false

    @State var selectedReminderType: Int = 0
//    @State var selectedDay: Int = 0
    @State var selectedUnitType: Int = 0

    @State var addedWeekReminders = [WeekReminderData]()
    @State var addedDayReminders = [DayReminderData]()

    @FocusState private var focusField: Field?

    init(habit: ActiveHabit) {
        self.habit = habit
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.secondarySystemFill
    }

    var body: some View {
        
        Form {
            TextField("Name", text: $name)
                .focused($focusField, equals: .name)
                .onSubmit { self.focusNextField($focusField) }
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

            Section("Unit") {
                Picker(selection: $selectedUnitType, label: Text("What do you want to track")) {
                    ForEach(0..<UnitTypes.allCases.count, id: \.self) { index in
                        Text("\(UnitTypes.allCases[index].rawValue)").tag(index)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Repeat") {
                HStack {
                    TextField("1", text: $repeatAmount)
                        .keyboardType(.numberPad)
                        .focused($focusField, equals: .repeatAmount)
                        .onSubmit { self.focusNextField($focusField) }
                        .frame(width: 50)
                    Text("/ per")
                    Spacer()
                    Picker(selection: $selectedReminderType, label: Text("How often do you want to be reminded")) {
                        ForEach(0..<RepeatType.allCases.count, id: \.self) { (index) in
                            Text("\(RepeatType.allCases[index].rawValue.capitalized)").tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            Section("Reminder") {
                Toggle(isOn: $useReminder, label: {
                    Text("Want to get reminded?")
                })
                if useReminder {
                    if selectedReminderType == 0 {
                        Button("Add") {
                            addDayReminderToArray()
                        }
                        ForEach(addedDayReminders, id: \.id) { reminder in
                            AddDayReminderView(reminder: reminder)
                        }
                    } else if selectedReminderType == 1 {
                        Button("Add") {
                            self.addWeekReminderToArray()
                        }
                        ForEach(addedWeekReminders, id: \.id) { reminder in
                            AddWeekReminderView(reminder: reminder)
                        }
                    } else if selectedReminderType == 2 {
                        Text("Comming Soon")
                    }
                }
            }
            Button("Save") {
              let _ =   StorageProvider.shared.saveActiveHabit(
                    name: name,
                    color: selectedColor,
                    positiveHabit: positiveHabit == 0 ? true : false,
                    repeatInterval: RepeatType.allCases[selectedReminderType].rawValue,
                    time: time,
                    unit: UnitTypes.allCases[selectedUnitType].rawValue,
                    repeatAmount: Int(repeatAmount) ?? 1,
                    reminders: useReminder,
                    reminderType: selectedReminderType,
                    addedWeekReminders: addedWeekReminders,
                    addedDayReminders: addedDayReminders
                )
                dismiss()
            }
        }
        //        .onTapGesture {
        //            self.hideKeyboard()
        //        }
        .navigationTitle(habit.habitName)
        .onAppear{
            name = habit.habitName
            selectedColor = colorStringToEnum(colorString: habit.habitColor)
            repeatInterval = habit.habitRepeatInterval
            repeatAmount = String(habit.habitRepeatAmount)
            time = habit.habitTime
            
            for index in 0..<UnitTypes.allCases.count {
                if UnitTypes.allCases[index].rawValue == habit.habitUnit {
                    selectedReminderType = index
                    break
                }
            }
            
            positiveHabit = habit.habitPositiveHabit ? 0 : 1
        
            useReminder = habit.habitHasReminders
           
            selectedReminderType = habit.habitDayReminders.count != 0 ? 0 : habit.habitWeekReminders.count != 0 ? 1 : 2
            
            
            if habit.habitDayReminders.count != 0 {
                var dayArray = [DayReminderData]()
                for reminder in habit.habitDayReminders {
                    let day = DayReminderData()
                    day.time = reminder.dayReminderTime
                    dayArray.append(day)
                }
                addedDayReminders = dayArray
                
            } else if habit.habitWeekReminders.count != 0 {
                var weekArray = [WeekReminderData]()
                for reminder in habit.habitWeekReminders {
                    let week = WeekReminderData()
                    week.day = reminder.weekReminderDay
                    week.time = reminder.weekReminderTime
                    
                    weekArray.append(week)
                }
                addedWeekReminders = weekArray
 
            }
            
            
            
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button { self.focusPreviousField($focusField) } label: {
                    Image(systemName: "chevron.up")
                }.disabled(self.isFirstField($focusField))
                Button { self.focusNextField($focusField) } label: {
                    Image(systemName: "chevron.down")
                }
                .disabled(self.isLastField($focusField, enumLength: Field.allCases.count))
                Spacer()
                Button("Done") {
                    focusField = nil
                }
            }
        }
        .sheet(isPresented: $showColorSheet) {
            VStack {
                HStack {
                    Spacer()
                    Button("Cancle") {
                        showColorSheet.toggle()
                    }.padding()
                }
                List {
                    ForEach(ActiveHabitColor.allCases, id: \.rawValue) { color in
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
    func addDayReminderToArray() {
        addedDayReminders.append(DayReminderData())
    }
    func addWeekReminderToArray() {
        addedWeekReminders.append(WeekReminderData())
    }
}
