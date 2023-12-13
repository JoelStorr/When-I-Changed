//
//  PushNotifications.swift
//  WhenIChanged
//
//  Created by Joel Storr on 13.12.23.
//

import Foundation
import UserNotifications
import SwiftUI


func checkForPermission(){
    let notificationCenrter = UNUserNotificationCenter.current()
    notificationCenrter.getNotificationSettings(){ settings in
        // Tells what the current state of the App is regading permissions
        switch settings.authorizationStatus {
        case .notDetermined:
            //If the user wasn't asked jet
            notificationCenrter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                if didAllow {
                    dispatchNotification()
                }
            }
        case .denied:
            return
        case .authorized:
            dispatchNotification()
        case .provisional:
            return
        case .ephemeral:
            return
        default:
            return
        }
    }
}


func dispatchNotification(){
    let id = "my-morning-notification"
    let title = "Time to work out"
    let body = "Don't be lazy, just do it."
    let hour = 15
    let minute = 10
    let isDaily  = true
        
    let notificationCenter = UNUserNotificationCenter.current()
//    let badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
    
    // Notification Content
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
//    notificationCenter.requestAuthorization(options: .badge){ (granted, error) in
//        if error != nil {
//            UIApplication.shared.applicationIconBadgeNumber = 1
//        }
//        
//    }
//    
    // Sets when the Notification should run
    let calendar = Calendar.current
    var dateComeponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
    dateComeponent.hour = hour
    dateComeponent.minute = minute
    
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComeponent, repeats: isDaily)
    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    
    // Delete all old Notifications with the same id
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    
    // Add New Notification
    notificationCenter.add(request)
}
