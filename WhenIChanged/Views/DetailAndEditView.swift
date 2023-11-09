//
//  DetailAndEditView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.08.23.
//

import SwiftUI

struct DetailAndEditView: View {
    @Binding var selectedHabit: PassivHabit
    @State private var name = ""
    
    @State var timeString: String = ""
    @State var firstCall = true
    
    @Binding var editing: Bool
    
    var body: some View {
        
        VStack{
            if editing {
                Form{
                    TextField(selectedHabit.habitName, text: $name)
                    Button("Done"){
                        
                        if name.isEmpty {
                            
                            return
                        }
                        selectedHabit.habitName = name
                        
                        StorageProvider.shared.save()
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
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.red.opacity(0.9))
                            .frame(width: .infinity, height: 50)
                        Label("Reset", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    
                }
                
                Spacer()
            }
        }
        .navigationTitle(editing ? "Edit" : "Detail")
        .onAppear(perform: timeManager)
    }
    
    
    func timeManager(){
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: selectedHabit.habitLatestDate, to: Date.now)
        
        
        if firstCall {
            firstCall = false
            DispatchQueue.main.asyncAfter(deadline: .now()){
                timeString = selectedHabit.timeSpan()
                timeManager()
                return
            }
            
        }
        
        guard let hour = difference.hour else { return }
        
        if hour > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                timeString = selectedHabit.timeSpan()
                timeManager()
            }
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                timeString = selectedHabit.timeSpan()
                timeManager()
            }
        }
        
        
    }
}
