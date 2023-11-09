//
//  Card.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.08.23.
//

import SwiftUI

struct Card: View {
    
    var habit: PassivHabit
    
    // var name : String
    // var time : () -> String
    @State var timeString: String = ""
    // var startedString : String
    @State var firstCall = true
    
    let earlyDate = Calendar.current.date(
      byAdding: .minute,
      value: -1,
      to: Date())
    
    var body: some View {
        VStack(alignment: .leading){
            Text(habit.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(timeString)
                .fontWeight(.bold)
            
            Text("Started: \(habit.startDateString)")
                .font(.caption)
        }
        .frame(width: 175, height: 100)
        .background(Color.orange)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .foregroundColor(.white)
        .onAppear(perform: timeManager)
    }
    
    
    
    
     func timeManager(){
         let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
         let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: habit.latestDate, to: Date.now)
         
         
         if firstCall {
             firstCall = false
             DispatchQueue.main.asyncAfter(deadline: .now()){
                 timeString = habit.timeSpan()
                 timeManager()
                 return
             }
             
         }
         
         guard let hour = difference.hour else { return }
         
         if hour > 0 {
             DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                 timeString = habit.timeSpan()
                 timeManager()
             }
         } else {
             
             DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                 timeString = habit.timeSpan()
                 timeManager()
             }
         }
         
         
         
         
//         self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//           timeString =  time()
//        })
    }
    
    
}


