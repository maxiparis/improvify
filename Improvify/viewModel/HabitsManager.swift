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
    var habits: [Habit] = []
    var dateSelected: Date {
        didSet {
            dateString = dateFormatter.string(from: dateSelected)
        }
    }
    let calendar = Calendar.current
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
        
        fetchData()
        
        if habits.isEmpty {
            print("habits are empty")
            createDefaultData()
            fetchData()
        }
    }
    
    //MARK: - Util
    
    func formatDateString() {
        dateString = dateFormatter.string(from: dateSelected)
    }
    
    func habitIsCompleted(_ habit: Habit) -> Bool {
        for dateCompleted in habit.completed {
            if calendar.isDate(dateSelected, inSameDayAs: dateCompleted) {
                return true
            }
        }
        
        return false
    }
    
    //MARK: - Data Handling
    
    func fetchData() {
        try? modelContext.save()
        
        do {
            let habitsDescriptot = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.name)])
            habits = try modelContext.fetch(habitsDescriptot)
        } catch {
            print("failed to fetch data")
        }
    }
    
    func createDefaultData() {
        let habitsToAdd = [
            Habit(name: "Do Exercisse", completeBy: "01:00pm", completed: [Date()]),
            Habit(name: "Pray", completeBy: "08:00am"),
        ]
        
        for habit in habitsToAdd {
            modelContext.insert(habit)
        }
        
        try? modelContext.save()
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

    func goToToday() {
        dateSelected = Date()
    }
    
    func handleTappingOnHabit(_ habit: Habit) {
        
        if habitIsCompleted(habit) {
            habit.completed.removeAll { date in
                calendar.isDate(date, inSameDayAs: dateSelected)
            }
        } else {
            habit.completed.append(dateSelected)
        }
    }
    
    func handleOnDelete(at index: IndexSet) {
        if let position = index.first {
            let removed = habits.remove(at: position)
            
            modelContext.delete(removed)
            try? modelContext.save()
        }
    }
}




