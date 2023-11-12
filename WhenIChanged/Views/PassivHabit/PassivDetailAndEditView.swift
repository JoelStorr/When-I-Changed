//
//  PassivDetailAndEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct PassivDetailAndEditView: View {
    
    @Binding var changeView: PassivViewType
    @Binding var selectedHabit: PassivHabit
    @State private var name = ""
    @State var timeString: String = ""
    @State var firstCall = true
    @Binding var editing: Bool
    @State var showSheet = false
    @State var showColorSheet = false
    @State var selectedColor: String? = nil
    
    var body: some View {
        VStack{
            if editing {
                Form{
                    TextField(selectedHabit.habitName, text: $name)
                    
                    HStack {
                        Button("Select Color") {
                            showColorSheet.toggle()
                        }
                        Spacer()
                            .frame(minWidth: 20)
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(selectedColor == nil ?  cardColorConverter(color: selectedHabit.habitColor) : cardColorConverter(color: selectedColor!))
                    }
                    Button("Done"){
                        if !name.isEmpty {
                            selectedHabit.habitName = name
                        }
                        
                        if selectedColor != nil {
                            selectedHabit.habitColor = selectedColor!
                        }
                        StorageProvider.shared.save()
                        editing.toggle()
                        changeView = .editPassivHabitView
                    }
                }
            } else {
                Spacer()
                    .frame(height: 20)
                ZStack(alignment: .top){
                    RoundedRectangle(cornerRadius: 5)
                        .fill(cardColorConverter(color: selectedHabit.habitColor))
                        .frame(maxHeight: 150)
                    VStack(spacing: 20){
                        HStack{
                            Text(selectedHabit.habitName)
                                .font(.system(size: 25, weight: .black))
                            Spacer()
                        }
                        Text(timeString)
                            .font(.system(size: 30, weight: .black))
                            .fontWeight(.bold)
                        HStack{
                            Spacer()
                            Text("Started at \(selectedHabit.startDateString)")
                        }
                    }
                    .padding()
                }
                Button{
                    StorageProvider.shared.resetCurrentHabitStreak(selectedHabit)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.red.opacity(0.9))
                            .frame( height: 50)
                        Label("Reset", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                
                Button("Show all resets") {
                    showSheet.toggle()
                }
                
                
                Spacer()
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(cardColorConverter(color: selectedHabit.habitColor).opacity(0.5))
                        .frame(maxHeight: 150)

                    VStack {
                        HStack {
                            Text("States")
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Text("\(selectedHabit.habitResetDates.count > 0 ? selectedHabit.habitResetDates.count - 1 : 0)")
                                Text("Resets")
                            }
                            Spacer()
                            VStack {
                                Text("\(selectedHabit.calculateLongestStreak()) days")
                                Text("Longest Streak")
                            }
                        }
                        HStack {
                            VStack{
                                Text("\(selectedHabit.timeSinceStart())")
                                Text("Since Started")
                            }
                            Spacer()
                            VStack {
                                Text("\(selectedHabit.calculateAvaregStreakLength()) days")
                                Text("Avarage Streak")
                            }
                        }
                    }.padding()
                }
                
                
            }
        }
        .navigationTitle(editing ? "Edit" : "Detail")
        .onAppear(perform: timeManager)
        .sheet(isPresented: $showSheet) {
            List {
                ForEach( selectedHabit.habitResetDates, id: \.self ) { reset in
                    Text("\(reset.wrappedResetDate)")
                }
            }
        }
        .sheet(isPresented: $showColorSheet) {
            List {
                ForEach(CardColor.allCases, id: \.rawValue) {color in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(cardColorConverter(color: color.rawValue))
                        .onTapGesture {
                            showColorSheet.toggle()
                            selectedColor = color.rawValue
                        }
                    
                    
                }
            }
        }
            
    }
    
    func timeManager() {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: selectedHabit.habitLatestDate, to: Date.now)

        if firstCall {
            firstCall = false
            DispatchQueue.main.asyncAfter(deadline: .now()){
                timeString = selectedHabit.timeFromLastReset()
                timeManager()
                return
            }
        }
        guard let hour = difference.hour else { return }
        if hour > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                timeString = selectedHabit.timeFromLastReset()
                timeManager()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                timeString = selectedHabit.timeFromLastReset()
                timeManager()
            }
        }
    }
}
