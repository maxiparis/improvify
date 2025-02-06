//
//  HabitsManager.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData
import SwiftUI

let DAILY_RAW_VALUE = HabitRecurrence.daily.rawValue
let WEEKLY_RAW_VALUE = HabitRecurrence.weekly.rawValue

@Observable
class HabitsManager {
    
    //MARK: - Properties
    private var modelContext: ModelContext
    var dailyHabits: [Habit] = []
    var weeklyHabits: [Habit] = []
    
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
    var newHabitRecurrence: HabitRecurrence = .daily
    
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
    
    var currentTab = 0 // Controls the current tab in the tabView
    
    var isDateAnimating = false // Controls the animation of the Date string, specially for when we are in today and we tap "Today"
    
    let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        
    //MARK: - Init
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        dateSelected = Date()
        formatDateString()
        
        fetchData()
        
        if dailyHabits.isEmpty {
            print("habits are empty")
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
    
    func completedHabitFeedback() {
        hapticGenerator.impactOccurred()
        SoundManager.shared.playSound(named: "success-sound")
    }
    
    //MARK: - Data Handling
    
    func fetchData() {
        try? modelContext.save()
        
        do {
            let dailyHabitsDescriptor = FetchDescriptor<Habit>(
                predicate: #Predicate<Habit>{$0.recurrence == DAILY_RAW_VALUE},
                sortBy: [SortDescriptor(\.completeByTime)]
            )
            dailyHabits = try modelContext.fetch(dailyHabitsDescriptor)
            
            let weeklyHabitsDescriptor = FetchDescriptor<Habit>(
                predicate: #Predicate<Habit> { $0.recurrence == WEEKLY_RAW_VALUE },
                sortBy: [SortDescriptor(\.completeByTime)]
            )
            weeklyHabits = try modelContext.fetch(weeklyHabitsDescriptor)
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
    }
    
    func moveDayBackward() {
        currentTab = -1
    }
    
    func goToToday(todayAnimated: Bool = true) {
        withAnimation {
            let today = Date()
            if Calendar.current.isDate(dateSelected, inSameDayAs: today) {
                if todayAnimated {
                    withAnimation {
                        isDateAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeIn(duration: 0.2)) {
                            self.isDateAnimating = false // Shrink back automatically
                        }
                    }
                }
            } else {
                if dateSelected < today { //we are in the past
                    dateSelected = Calendar.current.date(byAdding: .day, value: -1, to: today)!
                    moveDayForward()
                } else { //we are in the future
                    dateSelected = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                    moveDayBackward()
                }
                
            }
        }
    }
    
    func handleTappingOnHabitCheckmark(_ habit: Habit, on date: Date) {
        if habitIsCompleted(habit, on: date) {
            habit.completed.removeAll { datesCompleted in
                calendar.isDate(datesCompleted, inSameDayAs: date)
            }
        } else {
            habit.completed.append(date)
            completedHabitFeedback()
        }
    }
    
    func handleDelete(habit: Habit) {
        let removed: Habit?
        
        if habit.recurrence == DAILY_RAW_VALUE {
            removed = dailyHabits.remove(at: dailyHabits.firstIndex(of: habit)!)
        } else {
            removed = weeklyHabits.remove(at: weeklyHabits.firstIndex(of: habit)!)
        }
        
        guard let habitRemoved = removed else {
            print("habit to be be removed was not found.")
            return
        }
        
        modelContext.delete(habitRemoved)
        try? modelContext.save()
        
        NotificationManager.deleteDailyReminderFor(habitRemoved)
    }
    
    func createNewHabit() {
        let newHabit = Habit(name: newHabitName, completeByDate: newHabitTime, recurrence: newHabitRecurrence.rawValue)
        
        if newHabit.recurrence == HabitRecurrence.daily.rawValue {
            dailyHabits.append(newHabit)
        } else {
            weeklyHabits.append(newHabit)
        }
        
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




