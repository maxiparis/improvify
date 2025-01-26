//
//  File.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/25/25.
//

import Foundation
import UserNotifications

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
                print("Notification scheduled for habit \(habit.name)")
            }
        }
    }
    
    static func modifyDailyReminderFor(_ habit: Habit) {
        deleteDailyReminderFor(habit)
        createDailyReminderFor(habit)
    }
    
    static func deleteDailyReminderFor(_ habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("Reminders removed for habit \(habit.name)")
    }
}
