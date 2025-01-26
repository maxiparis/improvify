//
//  Habit.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var completeBy: String {
        completeByTime.toTimeString()
    }
    var completeByTime: Date //TODO: make this a DateComponent?
    var completed: [Date]
    var tags: [String]
    

    init(name: String, completeByDate: Date, completed: [Date] = [], tags: [String] = []) {
        self.name = name
        self.completeByTime = completeByDate
        self.completed = completed
        self.tags = tags
    }
}
