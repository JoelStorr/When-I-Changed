//
//  StorageProvider.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

import Foundation
import CoreData

final class StorageProvider {

    static let shared = StorageProvider()

    let persistentConteiner: NSPersistentContainer

    private init(){
        persistentConteiner = NSPersistentContainer(name: "Model")
        persistentConteiner.loadPersistentStores(completionHandler: {description, error in
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
        
        let calender = Calendar.current
        let date = Date()
        
        // Check if we are a day away
        
        print(setUp.lastDayReset)
        
        
        if calender.isDate(setUp.lastDayReset!, inSameDayAs: .now){
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
            // TODO: Run day cleenup function
        }
        
        // Check if we are more then a week away
        let week = calender.numberOfDaysBetween(from: .now)
        if week > 0 && date.getWeekDay() == Date.WeekDay.monday  {
            
            setUp.lastWeekReset = .now
            save()
            
            // TODO: Run Week cleenup function
            resetWeekCheckAmount()
            
        }
    
        // TODO: Handle Custom Time Frames
        
        
    }
    
    
    func resetDayCheckAmount () {
        let request : NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        let activeHabitType = NSPredicate(format: "%K == %@", #keyPath(ActiveHabit.repeatInterval), RepeatType.Day.rawValue )
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
        let request : NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        let activeHabitType = NSPredicate(format: "%K == %@", #keyPath(ActiveHabit.repeatInterval), RepeatType.Week.rawValue )
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
        let fetchRequest : NSFetchRequest<Setup> = Setup.fetchRequest()
        
        do {
            let result = try persistentConteiner.viewContext.fetch(fetchRequest)
            if result.count == 0 { return nil}
            
            
            if result.count > 1 {
                fatalError("Something went wrong there should onlybe one Setup Entity")
            }
            
            return result[0]
            
        } catch {
            print("Error to load the requested Setup Instance. If this happens outside the first Start then something went wrong: \(error.localizedDescription)")
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
        
    ){
        let habit = ActiveHabit(context: persistentConteiner.viewContext)
        habit.id = UUID()
        habit.name = name
        habit.color = color != nil ? color!.rawValue : positiveHabit ? ActiveHabitColor.green.rawValue : ActiveHabitColor.red.rawValue
        habit.positiveHabit = positiveHabit
        habit.repeatAmount = Int16(repeatAmount)
        habit.unit = unit

        
        habit.repeatInterval = repeatInterval ?? RepeatType.Day.rawValue
        
        
        habit.startDate = .now
        
        if time != nil {
            habit.time = time
        }
        
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
        } catch {
            persistentConteiner.viewContext.rollback()
            print("Failed to save Active habit: \(error)")
        }
        
    }
    
    // NOTE: Save added Check for Active Habit
    func addCheckToActiveHabit(_ habit: ActiveHabit){
        habit.habitCheckAmount += 1
        
        
        if habit.habitPositiveHabit {
            if habit.habitCheckAmount >= habit.habitRepeatAmount {
                let checkedDay = CheckedDay(context: persistentConteiner.viewContext)
                checkedDay.checkedDay = .now
                habit.addToCheckedDay(checkedDay)
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
            try? persistentConteiner.viewContext.save()
        }
    }
}

// NOTE: Load Data
extension StorageProvider {

    func loadAllPassivHabits() -> [PassivHabit] {
        let fetchRequest: NSFetchRequest<PassivHabit> = PassivHabit.fetchRequest()
        
        do{
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
