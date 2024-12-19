//
//  HabitsManager.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData

@Observable
class HabitsManager {
    
    //MARK: - Properties
    private var modelContext: ModelContext
    var dateSelected: Date {
        didSet {
            dateString = dateFormatter.string(from: dateSelected)
        }
    }
    var dateString: String = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    //MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        dateSelected = Date()
        formatDateString()
    }
    
    //MARK: - Util
    
    func formatDateString() {
        dateString = dateFormatter.string(from: dateSelected)
    }

    
    //MARK: - User Intents
    func moveDayForward() {
        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: dateSelected) {
            dateSelected = nextDay
        } else {
            print("error moving day forward")
        }
    }
    
    func moveDayBackward() {
        if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: dateSelected) {
            dateSelected = previousDay
        } else {
            print("error moving day backwards")
        }
    }

    
}
