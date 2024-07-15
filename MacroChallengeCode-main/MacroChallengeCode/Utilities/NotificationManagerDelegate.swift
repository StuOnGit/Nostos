//
//  NotificationManagerDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 09/06/23.
//

import Foundation
import UserNotifications

// TODO: Set the correct timeInterval for notification scheduling

enum NotificationActions: String {
    case remind
}

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var uuidString = UUID().uuidString
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error
                print(error.localizedDescription)
            }
            if granted {
                print("DEBUG: Notification Allowed")
            } else {
                print("DEBUG: Notification Denied")
            }
        }
    }
    
    func createNotification(title: String, body: String, sunset: Date, start: Date) {
        
        if sunset.timeIntervalSince(start) >  0{
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
        }
        
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "SUNSET_REMINDER"
        
        let remindAction = UNNotificationAction(identifier: "REMIND_ACTION", title: "Remind me in 10 minutes", options: [])
        
        let category =
        UNNotificationCategory(identifier: "SUNSET_REMINDER",
                               actions: [remindAction],
                               intentIdentifiers: [],
                               options: .customDismissAction
        )
            center.setNotificationCategories([category])
            
            scheduleNotification(timeInterval: calculateTimeToReturn(eveningGoldenHourEnd: sunset, startTime: start))
        }
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .sound, .badge])
    }
    
    // Handle selected actions of notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "REMIND_ACTION":
            /* In case in the future we are going to implement quick actions */
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Consider going back, so that you can arrive before it gets too dark"
            uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: newTrigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error in scheduling new notification: \(error.localizedDescription)")
                } else {
                    print("New notification added successfully.")
                }
            }
            break
        default:
            print("Default")
            break
        }
        completionHandler()
    }
    
}
