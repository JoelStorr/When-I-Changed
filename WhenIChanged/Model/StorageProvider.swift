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
