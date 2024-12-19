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
    var completeBy: String
    var completed: [Date]
    var tags: [String]
    

    init(id: UUID, name: String, completeBy: String, completed: [Date], tags: [String]) {
        self.id = id
        self.name = name
        self.completeBy = completeBy
        self.completed = completed
        self.tags = tags
    }
}
