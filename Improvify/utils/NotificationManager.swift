//
//  File.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/25/25.
//

import Foundation
import UserNotifications

enum WeekdayNumber: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

class NotificationManager {
    
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted.")
            } else {
                print("❌ Notification permission denied.")
            }
        }
    }
    
    static func createDailyReminderFor(_ habit: Habit) {
        let content = UNMutableNotificationContent()
        content.title = "Make Today Count"
        content.body = "Remember your commitment to \"\(habit.name)\". Stay consistent—you’ve got this!"
        content.sound = .default
        
        // Create trigger
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.completeByTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // Daily reminder
        
        // Create request
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        // Add request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("🔔 Notification scheduled for habit \(habit.name)")
            }
        }
        printAllNotifications()
    }
    
    
    /// Weekdays:
    /// 1 = Sunday
    /// 2 = Monday
    /// ...
    /// 6 = Friday
    /// 7 = Saturday
    static func createWeeklyReminderFor(_ habit: Habit, on weekdays: [Int] = [WeekdayNumber.monday.rawValue]) {
        //TODO: test this function. It was written by chatgpt.
        
        let content = UNMutableNotificationContent()
        content.title = "Stay on Track!"
        content.body = "Remember your commitment to \"\(habit.name)\". Keep pushing forward!"
        content.sound = .default
        
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: habit.completeByTime)
        
        for weekday in weekdays {
            var dateComponents = timeComponents
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // Weekly reminder
            
            let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("🔔 Weekly notification scheduled for \(habit.name) on weekday \(weekday)")
                }
            }
            printAllNotifications()
        }
    }
    
    static func printAllNotifications() {
        print("--------------------------------------------------------")
        print("Printing all Notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            requests.forEach { request in
                print("\n>>> Notification")
                print("   Identifier: \(request.identifier)")
                print("   Content: \(request.content.body)")
                print("   Trigger: \(String(describing: request.trigger?.description ?? "No trigger"))")
            }
            print("\nEND of Printing all Notifications")
            print("--------------------------------------------------------\n\n")
        }
    }
    
    static func modifyDailyReminderFor(_ habit: Habit) {
        deleteDailyReminderFor(habit)
        
        habit.isDaily ? createDailyReminderFor(habit) : createWeeklyReminderFor(habit)
    }
    
    static func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        printAllNotifications()
    }
    
    static func deleteDailyReminderFor(_ habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("🔔❌ Reminders removed for habit \(habit.name)")
    }
}
