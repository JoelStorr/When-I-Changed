//
//  ActiveHabitDetailView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 22.11.23.
//

import SwiftUI

struct ActiveHabitDetailView: View {

    @ObservedObject var habit: ActiveHabit

    var body: some View {
        ViewThatFits{
            detailView
            ScrollView() {
              detailView
            }
        }
        .navigationTitle(habit.habitName)
    }
    
    
    var detailView: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            ZStack{
                RoundProgressBar(
                    progress: (1.0 / Double(habit.habitRepeatAmount)) * Double(habit.habitCheckAmount),
                    color: cardColorConverter(color: habit.habitColor)
                )
                .frame(width: 300, height: 300)
                HStack {
                    Button {
                        StorageProvider.shared.removeCheckFromActiveHabit(habit)
                    } label: {
                        Text("-")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                habit.habitCheckAmount == 0
                                ? cardColorConverter(color: habit.habitColor).opacity(0.5)
                                : cardColorConverter(color: habit.habitColor)
                            )
                    }
                    .disabled(habit.habitCheckAmount == 0)
                    Text("\(habit.habitCheckAmount) / \(habit.habitRepeatAmount)")
                        .font(.title)
                        .foregroundStyle(habit.habitCheckAmount == habit.habitRepeatAmount ? cardColorConverter(color: habit.habitColor) : Color.primary)
                    Button {
                        StorageProvider.shared.addCheckToActiveHabit(habit)
                    } label: {
                        Text("+")
                            .font(.system(size: 40))
                            .foregroundStyle(cardColorConverter(color: habit.habitColor))
                    }
                }
            }
            Spacer()
                .frame(height: 50)
            CalendarView(habitColor: cardColorConverter(color: habit.habitColor), checkedDays: habit.habitCheckedDay)
        }
    }
}

