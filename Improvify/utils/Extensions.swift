//
//  Extensions.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/25/25.
//

import Foundation

extension Date {
    func toTimeString() -> String {
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
            formatter.locale = Locale(identifier: "en_US_POSIX") // Consistent formatting
            return formatter
        }()
        
        return timeFormatter.string(from: self)
    }
    
    func toDateString() -> String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM d" // Day of the week, full month, and day of the month
            return formatter
        }()
        
        let component = DateComponents(hour: 5, minute: 10)
        return dateFormatter.string(from: self)
    }
}

/**
 For future reference when I want to change the Habit.completeByTime to a DateComponents type.
 func toTimeString() -> String {
    // Extract hour and minute from DateComponents
    guard let hour = self.hour, let minute = self.minute else {
        return "Invalid time" // Handle case where hour or minute is missing
    }
    
    // Determine AM or PM
    let period = hour >= 12 ? "PM" : "AM"
    
    // Convert hour to 12-hour format
    let formattedHour = hour > 12 ? hour - 12 : hour
    let formattedMinute = minute < 10 ? "0\(minute)" : "\(minute)"
    
    // Construct the time string
    return "\(formattedHour):\(formattedMinute) \(period)"
 }
 
 
 
 */
