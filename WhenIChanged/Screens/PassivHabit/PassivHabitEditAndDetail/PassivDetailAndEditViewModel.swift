//
//  PassivDetailAndEditViewModel.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.11.23.
//

import Foundation


extension PassivDetailAndEditView {
    
    @MainActor class ViewModel: ObservableObject {
        
        var selectedHabit: PassivHabit
        @Published var name = ""
        @Published var timeString: String = ""
        @Published var firstCall = true
        @Published var editing: Bool = false
        @Published var showSheet = false
        @Published var showColorSheet = false
        @Published var selectedColor: String? = nil
        
        init(selectedHabit: PassivHabit){
            self.selectedHabit = selectedHabit
        }
        
        
        func timeManager() {
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: selectedHabit.habitLatestDate, to: Date.now)

            if firstCall {
                firstCall = false
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    self.timeString = self.selectedHabit.timeFromLastReset()
                    self.timeManager()
                    return
                }
            }
            guard let hour = difference.hour else { return }
            if hour > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                    self.timeString = self.selectedHabit.timeFromLastReset()
                    self.timeManager()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.timeString = self.selectedHabit.timeFromLastReset()
                    self.timeManager()
                }
            }
        }
        
        
    }
    
}
