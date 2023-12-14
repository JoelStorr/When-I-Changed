//
//  StorageProvider.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

// swiftlint:disable todo

import Foundation
import CoreData

final class StorageProvider {
    static let shared = StorageProvider()
    let persistentConteiner: NSPersistentContainer
    let calender = Calendar.current
    private init() {
        persistentConteiner = NSPersistentContainer(name: "Model")
        persistentConteiner.loadPersistentStores(completionHandler: {_, error in
            if let error = error {
                fatalError("Core data store failed to load with error: \(error)")
            }
        })
    }
}

// NOTE: Setup
extension StorageProvider {
    func loadSettings () {
        let setUp: Setup? = loadSetUp()
        if setUp == nil {
            // Run first SetUp
            let setUpClass = Setup(context: persistentConteiner.viewContext)
            setUpClass.lastDayReset = .now
            setUpClass.lastWeekReset = .now
            save()
            print("Saved initial Setting")
            return
        }

        guard let setUp = setUp else {
            fatalError("There should habe been a propper setup")
        }

        let date = Date()

        // Check if we are a day away
        if calender.isDate(setUp.lastDayReset!, inSameDayAs: .now) {
            print("Same Day")
        } else {
            print("New Day")
        }

        let days = calender.numberOfDaysBetween(from: setUp.lastDayReset!)
        print(days)
        if days >= 1 {
            setUp.lastDayReset = .now
            save()
            print("In days")
            resetDayCheckAmount()
        }

        print(date.getWeekDay().rawValue)
        
        // Check if we are more then a week away
        let week = calender.numberOfDaysBetween(from: setUp.lastWeekReset!)
        
        print(date.calculateSunday(day: date.getWeekDay()))
        
        
        if week > 7 && date.getWeekDay() == Date.WeekDay.sunday{
            setUp.lastWeekReset = .now
            save()
            
            // TODO: Run Week cleenup function
            resetWeekCheckAmount()
            
        } else if week > 7 && date.getWeekDay().rawValue > Date.WeekDay.sunday.rawValue {
            setUp.lastWeekReset = date.calculateSunday(day: date.getWeekDay())
            save()

            // TODO: Run Week cleenup function
            resetWeekCheckAmount()

        }

        // TODO: Handle Custom Time Frames
    }

    func resetDayCheckAmount () {
        let request: NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        let activeHabitType = NSPredicate(
            format: "%K == %@",
            #keyPath(ActiveHabit.repeatInterval),
            RepeatType.day.rawValue
        )
        request.predicate = activeHabitType
        do {
            let result = try persistentConteiner.viewContext.fetch(request)
            print(result)
            for habit in result {
                habit.habitCheckAmount = 0
                print("Reset Day")
            }
            save()
        } catch {
            print("Error")
        }
    }

    func resetWeekCheckAmount () {
        let request: NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        let activeHabitType = NSPredicate(
            format: "%K == %@",
            #keyPath(ActiveHabit.repeatInterval),
            RepeatType.week.rawValue
        )
        request.predicate = activeHabitType
        do {
            let result = try persistentConteiner.viewContext.fetch(request)
            print(result)
            for habit in result {
                habit.habitCheckAmount = 0
                print("Reset Day")
            }
            save()
        } catch {
            print("Error")
        }
    }

    func loadSetUp() -> Setup? {
        let fetchRequest: NSFetchRequest<Setup> = Setup.fetchRequest()
        do {
            let result = try persistentConteiner.viewContext.fetch(fetchRequest)
            if result.count == 0 { return nil}
            if result.count > 1 {
                fatalError("Something went wrong there should onlybe one Setup Entity")
            }
            return result[0]
        } catch {
            print(
                """
                Error to load the requested Setup Instance.
                If this happens outside the first Start then something went wrong:
                """
                + error.localizedDescription
            )
            return nil
        }
    }
}

// NOTE: Save Data
extension StorageProvider {
    func savePassiveHabit(name: String) {
        let habit = PassivHabit(context: persistentConteiner.viewContext)
        habit.id = UUID()
        habit.name = name
        habit.cardColor = CardColor.red.rawValue
        habit.startDate = .now
        habit.latestDate = .now
        do {
            try persistentConteiner.viewContext.save()
            print("Saved new habit")
        } catch {
            persistentConteiner.viewContext.rollback()
            print("Failed to save habit: \(error)")
        }
    }

    // swiftlint:disable:next function_parameter_count
    func saveActiveHabit(
        name: String,
        color: ActiveHabitColor?,
        positiveHabit: Bool = true,
        repeatInterval: String?,
        time: Date?,
        unit: String?,
        repeatAmount: Int,
        reminders: Bool,
        reminderType: Int,
        addedWeekReminders: [WeekReminderData],
        addedDayReminders: [DayReminderData]
    ) -> ActiveHabit? {
        let habit = ActiveHabit(context: persistentConteiner.viewContext)
        habit.id = UUID()
        habit.name = name
        habit.color = color != nil ? color!.rawValue
            : positiveHabit ? ActiveHabitColor.green.rawValue
            : ActiveHabitColor.red.rawValue
        habit.positiveHabit = positiveHabit
        habit.repeatAmount = Int16(repeatAmount)
        habit.unit = unit
        habit.repeatInterval = repeatInterval ?? RepeatType.day.rawValue
        habit.startDate = .now
        habit.hasReminders = reminders

        if time != nil {
            habit.time = time
        }

        // Repeattype: Day = 0, Week = 1, Month = 2
        
        if reminderType == 0 && reminders {
            for unsavedReminder in addedDayReminders {
                let reminder = DayReminder(context: persistentConteiner.viewContext)
                reminder.time = unsavedReminder.time
                habit.addToDayReminders(reminder)
            }
        } else if reminderType == 1 && reminders {
            for unsavedReminder in addedWeekReminders {
                let reminder = WeekReminder(context: persistentConteiner.viewContext)
                reminder.day = Int16(unsavedReminder.day)
                reminder.time = unsavedReminder.time
                habit.addToWeekReminders(reminder)
            }
        }
        do {
            try persistentConteiner.viewContext.save()
            print("Saved new Active habit")
            print(habit)
            
            if reminders && reminderType == 0  {
                
                var notificationArray = [NotificationItem]()
                
                for addedDayReminder in habit.habitDayReminders {
                    let item = NotificationItem(
                        id: habit.habitId,
                        title: habit.habitName,
                        body: "You can do it",
                        dateData: addedDayReminder,
                        isDayli: true
                    )
                    
                    notificationArray.append(item)
                }
                
                NotificationHandler.checkForPermission(notificationArray)
                
                
            }
            
            
            
            
            return habit
            
            
            
        } catch {
            persistentConteiner.viewContext.rollback()
            print("Failed to save Active habit: \(error)")
            return nil
        }
    }

    // NOTE: Save added Check for Active Habit
    func addCheckToActiveHabit(_ habit: ActiveHabit, date: Date = .now) {
        habit.habitCheckAmount += 1
        if habit.habitPositiveHabit {
            if habit.habitCheckAmount == habit.habitRepeatAmount {
                let checkedDay = CheckedDay(context: persistentConteiner.viewContext)
                checkedDay.checkedDay = date
                habit.addToCheckedDay(checkedDay)
            }
        }
        save()
    }
    
    func removeCheckFromActiveHabit(_ habit: ActiveHabit) {
        habit.habitCheckAmount -= 1
        if habit.positiveHabit {
            if habit.habitCheckAmount < habit.habitRepeatAmount {
                // TODO: Remove the check entry where the date is == to today
                let dayComplete = habit.habitCheckedDay.filter { calender.numberOfDaysBetween(from: $0.checkedDay!) == 0 }
                
                if !dayComplete.isEmpty {
                    for checkdDay in dayComplete {
                        persistentConteiner.viewContext.delete(checkdDay)
                        save()
                        print("Deleted Element")
                    }
                }
            }
        }
        save()
    }

    func completeCheckToActiveHabit(_ habit: ActiveHabit) {
        habit.habitCheckAmount += habit.habitRepeatAmount - habit.habitCheckAmount
        if habit.habitPositiveHabit {
            if habit.habitCheckAmount >= habit.habitRepeatAmount {
                let checkedDay = CheckedDay(context: persistentConteiner.viewContext)
                checkedDay.checkedDay = .now
                habit.addToCheckedDay(checkedDay)
            }
        }
        save()
    }

    func save () {
        if persistentConteiner.viewContext.hasChanges {
            do {
                try persistentConteiner.viewContext.save()
            }catch {
                persistentConteiner.viewContext.rollback()
                print("Falied to save changes: \(error)")
            }
        }
    }
}

// NOTE: Load Data
extension StorageProvider {
    func loadAllPassivHabits() -> [PassivHabit] {
        let fetchRequest: NSFetchRequest<PassivHabit> = PassivHabit.fetchRequest()
        do {
            return try persistentConteiner.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch PassivHabts: \(error)")
            return []
        }
    }

    func loadAllActiveHabits() -> [ActiveHabit] {
        let fetchRequest: NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        do {
            let result =  try persistentConteiner.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to load ActiveHabits: \(error)")
            return[]
        }
    }
}

// NOTE: Delete Elements
extension StorageProvider {
    func deletePassiveHabit(_ habit: PassivHabit) {
        persistentConteiner.viewContext.delete(habit)
        do {
            try persistentConteiner.viewContext.save()
        } catch {
            persistentConteiner.viewContext.rollback()
            print("Habit: \(habit.habitName) could not be deleted. \(error)")
        }
    }

    func deleteActiveHabit(_ habit: ActiveHabit) {
        
        if habit.habitHasReminders {
            
            var idArray = [String]()
            
            for reminder in habit.habitDayReminders {

                idArray.append(reminder.dayReminderNotificationId)
            }
            NotificationHandler.deleteNotification(id: idArray)
        }
        
        
        persistentConteiner.viewContext.delete(habit)
        do {
            try persistentConteiner.viewContext.save()
        } catch {
            persistentConteiner.viewContext.rollback()
            print("Habit: \(habit.habitName) could not be deleted. \(error)")
        }
    }
}

// NOTE: Reset Current Streak time
extension StorageProvider {
    func resetCurrentHabitStreak(_ habit: PassivHabit) {
        let resetDate = PastResets(context: persistentConteiner.viewContext)
        resetDate.resetDate = habit.latestDate
        habit.addToResetDates(resetDate)
        habit.latestDate = .now
        save()
    }
}

// NOTE: Add to active Habit
extension StorageProvider {
    func addToActiveHabit() {

    }
}

// swiftlint:enable todo
