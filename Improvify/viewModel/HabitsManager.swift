//
//  HabitsManager.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class HabitsManager {
    
    //MARK: - Properties
    private var modelContext: ModelContext
    var habits: [Habit] = []
    var dateSelected: Date {
        didSet {
            dateString = dateSelected.toDateString()
        }
    }
    let calendar = Calendar.current
    var dateString: String = ""
    
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
    
    var currentTab = 0 //controls the current tab in the tabView
    
    //MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        
        dateSelected = Date()
        formatDateString()
        
        fetchData()
        
        if habits.isEmpty {
            print("habits are empty")
//            createDefaultData()
            fetchData()
        }
    }
    
    //MARK: - Util
    
    func formatDateString() {
        dateString = dateSelected.toDateString()
    }
    
    func formatTime(from date: Date) -> String {
        return date.toTimeString().lowercased()
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
        Calendar.current.date(byAdding: .day, value: -1, to: dateSelected)!
    }

    func nextDay(_ date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: dateSelected)!
    }
    
    func createSpecificTimeDate(hour: Int, minute: Int) -> Date? {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        // Use the current calendar to generate the date
        return Calendar.current.date(from: components)
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
            Habit(name: "Do Exercisse", completeByDate: createSpecificTimeDate(hour: 13, minute: 0) ?? Date(), completed: [Date()]),
            Habit(name: "Pray", completeByDate: createSpecificTimeDate(hour: 8, minute: 0) ?? Date())
        ]
        
        for habit in habitsToAdd {
            modelContext.insert(habit)
        }
        
        try? modelContext.save()
    }


    
    //MARK: - User Intents
    func moveDayForward() {
        currentTab = 1

//        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: dateSelected) {
////                dateSelected = nextDay
//            currentTab = 1
//        } else {
//            print("error moving day forward")
//        }
    }
    
    func moveDayBackward() {
        currentTab = -1

//        if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: dateSelected) {
////                dateSelected = previousDay
//            currentTab = -1
//        } else {
//            print("error moving day backwards")
//        }
    }

    func goToToday() {
        withAnimation {
            let today = Date()
            if !Calendar.current.isDate(dateSelected, inSameDayAs: today) {
                if dateSelected < today { //we are in the past
                    dateSelected = Calendar.current.date(byAdding: .day, value: -1, to: today)!
                    moveDayForward()
                } else {
                    dateSelected = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                    moveDayBackward()
                }
            }
        }
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
    
    func handleDelete(habit: Habit) {
        let removed = habits.remove(at: habits.firstIndex(of: habit)!)
        
        modelContext.delete(removed)
        try? modelContext.save()
    }
    
//    func handleOnMove(from source: IndexSet, to destination: Int) {
//        habits.move(fromOffsets: source, toOffset: destination)
//        try? modelContext.save()
//    }
    
    func createNewHabit() {
        let newHabit = Habit(name: newHabitName, completeByDate: newHabitTime)
        habits.append(newHabit)
        
        modelContext.insert(newHabit)
        try? modelContext.save()
        
        NotificationManager.createDailyReminderFor(newHabit)
        presentAddHabitView = false
    }
    
    func handleEditHabit() {
        habitOnEdit!.name = editHabitName
        habitOnEdit!.completeByTime = editHabitTime
        NotificationManager.modifyDailyReminderFor(habitOnEdit!)
        
        
        presentEditHabitView = false
    }
}




