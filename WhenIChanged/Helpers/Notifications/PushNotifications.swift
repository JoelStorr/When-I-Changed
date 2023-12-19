//
//  PushNotifications.swift
//  WhenIChanged
//
//  Created by Joel Storr on 13.12.23.
//

import Foundation
import UserNotifications


class NotificationItem{
    let id: String
    let title: String
    let body: String
    let dateData: DayReminder
    let isDayli: Bool
    
    init(id: String, title: String, body: String, dateData: DayReminder, isDayli: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.dateData = dateData
        self.isDayli = isDayli
    }
}


class NotificationHandler{
    static let notificationCenter = UNUserNotificationCenter.current()

    static func checkForPermission(_ notificationList: [NotificationItem]){
        notificationCenter.getNotificationSettings(){ settings in
            // Tells what the current state of the App is regading permissions
            switch settings.authorizationStatus {
            case .notDetermined:
                //If the user wasn't asked jet
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    if didAllow {
                        dispatchNotification(notificationList)
                    }
                }
            case .denied:
                return
            case .authorized:
                dispatchNotification(notificationList)
            case .provisional:
                return
            case .ephemeral:
                return
            default:
                return
            }
        }
    }
    
    static func dispatchNotification(_ notificationList: [NotificationItem]){
        
        let calendar = Calendar.current

        for notification in notificationList {

            // Notification Content
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default
            //content.badge = 1

            // Sets when the Notification should run
            var dateComeponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
            dateComeponent.hour = CalendarHelper().getHour(notification.dateData.dayReminderTime)
            dateComeponent.minute = CalendarHelper().getMinute(notification.dateData.dayReminderTime)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComeponent, repeats: notification.isDayli)
            let id = UUID().uuidString

            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            notification.dateData.dayReminderNotificationId = id

            // Add New Notification
            notificationCenter.add(request)
        }
        
        let _ = StorageProvider.shared.save()
    }
    
    static func deleteNotifications(id: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: id)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: id)
    }

}
