//
//  Habit.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData

enum HabitRecurrence: String, CaseIterable {
    case daily = "daily"
    case weekly = "weekly"
}

@Model
class Habit: Identifiable {
    
    //MARK: - Properties

    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var completeBy: String {
        completeByTime.toTimeString()
    }
    var completeByTime: Date //TODO: make this a DateComponent?
    var completed: [Date]
    var tags: [String]
    var recurrence: String
    
    
    //MARK: - Init

    init(name: String, completeByDate: Date, completed: [Date] = [], tags: [String] = [], recurrence: String = HabitRecurrence.daily.rawValue) {
        self.name = name
        self.completeByTime = completeByDate
        self.completed = completed
        self.tags = tags
        self.recurrence = recurrence
    }
}
