//
//  HabitGraphManager.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/1/25.
//

import Foundation

@Observable
class HabitGraphManager {
    
    //MARK: - Properties

    var habit: Habit
    var data: [LineChartElement] = []
    var last15recurrences: [Date] = []
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
    var calendar: Calendar {
        var newCal = Calendar.current
        newCal.timeZone = TimeZone.current
        return newCal
    }
    var cumulativeCounts: [Int] = []


    //MARK: - Init
    init(habit: Habit) {
        self.habit = habit
        if habit.isDaily {
            generateDailyData()
        } else {
            generateWeeklyData()
        }
    }

    //MARK: - Logic

    func lastMonday(using calendar: Calendar = .current) -> Date? {
        let today = calendar.startOfDay(for: Date()) // Normalize to start of day
        let weekday = calendar.component(.weekday, from: today)
        
        // If today is monday, return today
        if weekday == 2 {
            return today
        }
        
        return calendar.nextDate(after: today, matching: DateComponents(weekday: 2), matchingPolicy: .previousTimePreservingSmallerComponents, direction: .backward)
    }

    
    //MARK: - Logic
    func generateDailyData() {
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        // Create today's date (midnight in the current time zone)
        if let today = calendar.date(from: todayComponents) {
            for i in 0..<15 {
                if let date = calendar.date(byAdding: .day, value: i-14, to: today) {
                    last15recurrences.append(date)
                    let previousDayCount = cumulativeCounts.last ?? 0
                    if habit.completed.contains(where: { calendar.isDate(date, inSameDayAs: $0) }) { //completed on that day
                        //+1
                        let thisDayCount = previousDayCount+1
                        cumulativeCounts.append(thisDayCount)
                        data.append(LineChartElement(date: date, value: thisDayCount))
                    } else { //NOT completed on that day
                        //-1
                        let thisDayCount = max(previousDayCount-1, 0) //never goes under 0.
                        cumulativeCounts.append(thisDayCount)
                        data.append(LineChartElement(date: date, value: thisDayCount))
                    }
                }
            }
        }
    }
    
    func generateWeeklyData() {
        if let lastMonday = lastMonday(using: calendar) {
            for i in 0..<15 {
                
                // Monday = first day of week
                // Sunday = last day of week
                if let monday = calendar.date(byAdding: .day, value: 7*(i-14), to: lastMonday),
                    let sunday = calendar.date(byAdding: .day, value: 6, to: monday) {
                    last15recurrences.append(monday)
                    
                    let normalizedMonday = calendar.startOfDay(for: monday)
                    let normalizedSunday = calendar.startOfDay(for: sunday)
                    
                    let previousWeekCount = cumulativeCounts.last ?? 0
                    
                    /// This `contains` statement checks if there is at least one date in the `completed` array
                    /// that is between monday and sunday (inclusive), in that week.
                    /// If so, that means that habit was completed in that week.
                    if habit.completed.contains(where: { date in
                        let normalizedDate = calendar.startOfDay(for: date)
                        return normalizedMonday...normalizedSunday ~= normalizedDate
                    }) {
                        //+1
                        let thisWeekCount = previousWeekCount+1
                        cumulativeCounts.append(thisWeekCount)
                        data.append(LineChartElement(date: monday, value: thisWeekCount))
                    } else { //NOT completed on that week
                        //-1
                        let thisDayCount = max(previousWeekCount-1, 0) //Never goes under 0
                        cumulativeCounts.append(thisDayCount)
                        data.append(LineChartElement(date: monday, value: 0))
                    }
                }
            }
        }
    }
}

struct LineChartElement: Identifiable {
    var id: UUID = UUID()
    let date: Date
    let value: Int
}
