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
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Use 12-hour format with AM/PM
        formatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistent formatting
        return formatter
    }
    
    var presentAddHabitView = false
    var newHabitName = ""
    var newHabitTime: Date = Date()
    
    var presentEditHabitView = false
    var habitOnEdit: Habit? {
        didSet {
            if let habitOnEdit {
                editHabitName = habitOnEdit.name
                editHabitTime = createDate(from: habitOnEdit.completeBy) ?? Date()
            }
        }
    }
    var editHabitName = ""
    var editHabitTime = Date()
    
    var presentGraphView = false
    var graphSelectedHabit: Habit?
    
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
    
    func formatTime(from date: Date) -> String {
        return timeFormatter.string(from: date).lowercased()
    }
    
    func habitIsCompleted(_ habit: Habit, on date: Date) -> Bool {
        for dateCompleted in habit.completed {
            if calendar.isDate(date, inSameDayAs: dateCompleted) {
                return true
            }
        }
        
        return false
    }
    
    func createDate(from timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from: timeString)
        return date
    }
    
    func previousDay(_ date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: -1, to: date)!
    }

    func nextDay(_ date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: date)!
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
    
    func handleTappingOnHabit(_ habit: Habit, on date: Date) {
        if habitIsCompleted(habit, on: date) {
            habit.completed.removeAll { datesCompleted in
                calendar.isDate(datesCompleted, inSameDayAs: date)
            }
        } else {
            habit.completed.append(date)
        }
    }
    
    
    func handleOnDelete(at index: IndexSet) {
        if let position = index.first {
            let removed = habits.remove(at: position)
            
            modelContext.delete(removed)
            try? modelContext.save()
        }
    }
    
//    func handleOnMove(from source: IndexSet, to destination: Int) {
//        habits.move(fromOffsets: source, toOffset: destination)
//        try? modelContext.save()
//    }
    
    func createNewHabit() {
        let newHabit = Habit(name: newHabitName, completeBy: formatTime(from: newHabitTime))
        habits.append(newHabit)
        
        modelContext.insert(newHabit)
        try? modelContext.save()
        
        presentAddHabitView = false
    }
    
    func handleEditHabit() {
        habitOnEdit!.name = editHabitName
        habitOnEdit!.completeBy = formatTime(from: editHabitTime)
        
        presentEditHabitView = false
    }
}




