//
//  DateHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.11.23.
//

import Foundation

extension Calendar {
    // swiftlint:disable:next identifier_name
    func numberOfDaysBetween(from: Date, to: Date = .now) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        return numberOfDays.day!
    }
}

extension Date {
    enum WeekDay: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }

    func getWeekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDay(rawValue: weekDay)!
    }
    
    func calculateSunday(day: WeekDay) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: -(day.rawValue - 1), to: Date()) else {
            return .now
        }
        return date
    }
    func calculateMonday(day: WeekDay) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: -(day.rawValue - 2), to: Date()) else {
            return .now
        }
        return date
    }
}

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}



class dateHolder: ObservableObject {
    @Published var date : Date = .now
}

