//
//  StorageProvider.swift
//  WhenIChanged
//
//  Created by Joel Storr on 09.11.23.
//

// swiftlint:disable todo

import SwiftUI
import CoreData


enum SetupStatus {
    case hasNoSetUp, hasMoreThenOneSetUp, hasSetup
}


final class StorageProvider: ObservableObject{
    static let shared = StorageProvider()
    let persistentConteiner: NSPersistentContainer
    let calender = Calendar.current
    
    @Published var globalSetupClass: Setup = Setup()

    private init() {
        persistentConteiner = NSPersistentCloudKitContainer(name: "Model")
        
        persistentConteiner.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        persistentConteiner.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        
        persistentConteiner.loadPersistentStores(completionHandler: {_, error in
            if let error = error {
                fatalError("Core data store failed to load with error: \(error)")
            }
        })
        persistentConteiner.viewContext.automaticallyMergesChangesFromParent = true
        persistentConteiner.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        // Tells us when a change in cloudKit happens,
       // so we can have Cloud and local storage in sync
       persistentConteiner.persistentStoreDescriptions.first?.setOption(
           true as NSNumber,
           forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
       )
        
        // When the change happens pleas call the remoteStoreChanged
//       NotificationCenter.default.addObserver(
//           forName: .NSPersistentStoreRemoteChange,
//           object: persistentConteiner.persistentStoreCoordinator,
//           queue: .main, using: remoteStoreChanaged
//       )
    }
}

// NOTE: Setup
extension StorageProvider {
    func loadSettings () {
        let setUp: (status: SetupStatus, setupElement: Setup?) = loadSetUp()

        if setUp.status == SetupStatus.hasNoSetUp {
            // Run first SetUp
            let setUpClass = Setup(context: persistentConteiner.viewContext)
            setUpClass.lastDayReset = .now
            setUpClass.lastWeekReset = .now
            setUpClass.colorMode = ""
            setUpClass.weekStartsMonday = true
           let _ = save()
            
            globalSetupClass = setUpClass
            print("Saved initial Setting")
            return
        } else {
            guard let setupElement = setUp.setupElement else {
                fatalError("There should habe been a propper setup")
            }

            let date = Date()

            let days = calender.numberOfDaysBetween(from: setupElement.lastDayReset!)
            if days >= 1 {
                setupElement.lastDayReset = .now
                let _ = save()
                resetDayCheckAmount()
            }

            // Check if we are more then a week away
            let week = calender.numberOfDaysBetween(from: setupElement.lastWeekReset!)
            if week > 7 && date.getWeekDay() == Date.WeekDay.sunday{
                setupElement.lastWeekReset = .now
                let _ = save()

                // TODO: Run Week cleenup function
                resetWeekCheckAmount()
            } else if week > 7 && date.getWeekDay().rawValue > Date.WeekDay.sunday.rawValue {
                setupElement.lastWeekReset = date.calculateSunday(day: date.getWeekDay())
                let _ = save()

                // TODO: Run Week cleenup function
                resetWeekCheckAmount()
            }
            // TODO: Handle Custom Time Frames

            let _ = save()
            
            globalSetupClass = setupElement
        }
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
            }
            let _ = save()
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
            }
            let _ = save()
        } catch {
            print("Error")
        }
    }

    func loadSetUp() -> (status: SetupStatus, setupElement: Setup?) {
        let fetchRequest: NSFetchRequest<Setup> = Setup.fetchRequest()
        do {
            let result = try persistentConteiner.viewContext.fetch(fetchRequest)
            if result.count == 0 { return (status: SetupStatus.hasNoSetUp, setupElement: nil) }
            if result.count > 1 {
             // NOTE: Uncomment to delet setup elements. Were generated to problamatic syncing
             // while setting up the iCloud
                for res in result {
                    persistentConteiner.viewContext.delete(res)
                }
                let _ = save()
                fatalError("Something went wrong there should only be one Setup Entity \(result.count)")
            } else {
                return (status: SetupStatus.hasSetup, setupElement: result[0])
            }
        } catch {
            print(
                """
                Error to load the requested Setup Instance.
                If this happens outside the first Start then something went wrong:
                """
                + error.localizedDescription
            )
            return (status: SetupStatus.hasNoSetUp, setupElement: nil)
        }
    }
}

// NOTE: Save Data
extension StorageProvider {
    func savePassiveHabit(name: String, startDate: Date, cardColor: String) {
        let habit = PassivHabit(context: persistentConteiner.viewContext)
        habit.id = UUID()
        habit.name = name
        habit.cardColor = cardColor
        habit.startDate = startDate
        habit.latestDate = startDate
        habit.position = Int16(loadAllPassivHabits().count)
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
        habit.position = Int16(loadAllActiveHabits().count) // TODO: Rethink how to get Positioning value

        if time != nil {
            habit.time = time
        }

        // Repeattype: Day = 0, Week = 1, Month = 2

        if repeatInterval == RepeatType.day.rawValue && reminders {
            for unsavedReminder in addedDayReminders {
                let reminder = DayReminder(context: persistentConteiner.viewContext)
                reminder.time = unsavedReminder.time
                habit.addToDayReminders(reminder)
            }
        } else if repeatInterval == RepeatType.week.rawValue && reminders {
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
            if reminders && repeatInterval == RepeatType.day.rawValue  {
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
    
    
    func saveSpecialDay(
        name: String,
        date: Date,
        color: String,
        repeatNextYear: Bool,
        
        dateToggle: Bool,
        font: String,
        image: Data,
        widgetSize: String
        
        
        
    
    )-> SpecialDay{
    
        
        let specialDay = SpecialDay(context: persistentConteiner.viewContext)
        
        specialDay.name = name
        specialDay.date = date
        specialDay.color = color
        specialDay.repeatNextYear = repeatNextYear
        specialDay.position = Int16(1) // TODO: Get the lenght of array to set position dynamically
        specialDay.dateToggle = dateToggle
        specialDay.font = font
        specialDay.image = image
        specialDay.widgetSize = widgetSize
        
        let _ = save()
        return specialDay
        
    }
    

    // NOTE: Update Extisting Active Habit
    func updateActiveHabit(
        habit: ActiveHabit,
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
        // NOTE: Does not have to be reset ?
        // habit.position = 1 // TODO: Sett Position

        if time != nil {
            habit.time = time
        }

        
        var notificationIds = [String]()
        for reminder in habit.habitDayReminders {
            notificationIds.append(reminder.dayReminderNotificationId)
            persistentConteiner.viewContext.delete(reminder)
        }
        for reminder in habit.habitWeekReminders {
            notificationIds.append(reminder.weekReminderNotificationId)
            persistentConteiner.viewContext.delete(reminder)
        }
        NotificationHandler.deleteNotifications(id: notificationIds)

        if repeatInterval == RepeatType.day.rawValue && reminders {
            for unsavedReminder in addedDayReminders {
                let reminder = DayReminder(context: persistentConteiner.viewContext)
                reminder.time = unsavedReminder.time
                habit.addToDayReminders(reminder)
            }
        } else if repeatInterval == RepeatType.week.rawValue && reminders {
            for unsavedReminder in addedWeekReminders {
                let reminder = WeekReminder(context: persistentConteiner.viewContext)
                reminder.day = Int16(unsavedReminder.day)
                reminder.time = unsavedReminder.time
                habit.addToWeekReminders(reminder)
            }
        }

      let saved = save()

        // NOTE: Generate new Notifications
        if saved {
            if reminders && repeatInterval == RepeatType.day.rawValue  {
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
       let _ =  save()
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
                        let _ = save()
                        print("Deleted Element")
                    }
                }
            }
        }
        let _ = save()
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
        let _ = save()
    }

    func save () -> Bool{
        if persistentConteiner.viewContext.hasChanges {
            do {
                try persistentConteiner.viewContext.save()
                return true
            }catch {
                persistentConteiner.viewContext.rollback()
                print("Falied to save changes: \(error)")
                return false
            }
        }
        return false
    }
}

// NOTE: Load Data
extension StorageProvider {
    func loadAllPassivHabits() -> [PassivHabit] {
        let fetchRequest: NSFetchRequest<PassivHabit> = PassivHabit.fetchRequest()
        do {
            let result =  try persistentConteiner.viewContext.fetch(fetchRequest)
            return result.sorted {$0.position < $1.position}
        } catch {
            print("Failed to fetch PassivHabts: \(error)")
            return []
        }
    }

    func loadAllActiveHabits() -> [ActiveHabit] {
        let fetchRequest: NSFetchRequest<ActiveHabit> = ActiveHabit.fetchRequest()
        do {
            let result =  try persistentConteiner.viewContext.fetch(fetchRequest)
            // Set all reminders
            resetAllReminders(habits: result)
            

            return result.sorted{ $0.position < $1.position}
        } catch {
            print("Failed to load ActiveHabits: \(error)")
            return[]
        }
    }
}


// NOTE: Edit Data
extension StorageProvider {
    
    func updatePassivHabitOrder(habits: [PassivHabit]){
        for index in 0..<habits.count{
            habits[index].habitPosition = index
        }
        
        let _ = save()
    }
    
    
    
    
    func updateActiveHabitOrder(habits: [ActiveHabit]){
        for index in 0..<habits.count{
            habits[index].habitPosition = index
        }
        
        let _ = save()
        
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
            NotificationHandler.deleteNotifications(id: idArray)
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
        let _ = save()
    }
}


// NOTE: Set reminders
extension StorageProvider {
    func resetAllReminders(habits: [ActiveHabit]) {

        var reminderIds = [String]()

        for habit in habits {

            for reminder in habit.habitDayReminders {
                reminderIds.append(reminder.dayReminderNotificationId)
            }

            for reminder in habit.habitWeekReminders {
                reminderIds.append(reminder.weekReminderNotificationId)
            }

            NotificationHandler.deleteNotifications(id: reminderIds)

            if habit.habitHasReminders && habit.habitRepeatInterval == RepeatType.day.rawValue {
                for _ in habit.habitDayReminders {
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
            } else if habit.hasReminders && habit.habitRepeatInterval == RepeatType.week.rawValue {
                // TODO: Add Week Reminders
            } else if habit.hasReminders && habit.habitRepeatInterval == RepeatType.month.rawValue {
                // TODO: Add Month Reminders
            }
        }
    }
}

// NOTE: Handle CloudKit
extension StorageProvider {
//    func remoteStoreChanaged(_ notification: Notification) {
//        print("-------------------------------------------------------------------")
//        print("Detected Changes")
//        print(notification.object)
//        print("-------------------------------------------------------------------")
//        
//            objectWillChange.send()
//    }
}

// swiftlint:enable todo



