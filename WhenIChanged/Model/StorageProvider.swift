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
        reminder: Date?,
        repeatInterval: String?,
        time: Date?,
        unit: String?,
        repeatAmount: Int
    ){
        let habit = ActiveHabit(context: persistentConteiner.viewContext)
        habit.id = UUID()
        habit.name = name
        habit.color = color != nil ? color!.rawValue : positiveHabit ? ActiveHabitColor.green.rawValue : ActiveHabitColor.red.rawValue
        habit.positiveHabit = positiveHabit
        habit.repeatAmount = Int16(repeatAmount)
        
        if reminder != nil {
            habit.reminder = reminder
        }
        
        if repeatInterval != nil {
            habit.repeatInterval = repeatInterval
        }
        
        habit.startDate = .now
        
        if time != nil {
            habit.time = time
        }
        
        if unit != nil {
            habit.unit = unit
        }
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
}

// NOTE: Reset Current Streak time
extension StorageProvider {
    func resetCurrentHabitStreak(_ habit: PassivHabit){
        
        let resetDate = PastResets(context: persistentConteiner.viewContext)
        resetDate.resetDate = habit.latestDate
        habit.addToResetDates(resetDate)
        habit.latestDate = .now
        
        save()
    }
}
