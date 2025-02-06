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
        var calendar = Calendar.current
        var cumulativeCounts: [Int] = []
        var temp: [LineChartElement] = []
        
        let currentTimeZone = TimeZone.current
        calendar.timeZone = currentTimeZone
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
                        temp.append(LineChartElement(date: date, value: thisDayCount))
                    } else { //NOT completed on that day
                        //-1
                        let thisDayCount = max(previousDayCount-1, 0) //never goes under 0.
                        cumulativeCounts.append(thisDayCount)
                        temp.append(LineChartElement(date: date, value: thisDayCount))
                    }
                }
            }
        }

        data = temp
    }
    
    func generateWeeklyData() {
        var calendar = Calendar.current
        var cumulativeCounts: [Int] = []
        var temp: [LineChartElement] = []
        
        let currentTimeZone = TimeZone.current
        calendar.timeZone = currentTimeZone
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        if let lastMonday = lastMonday(using: calendar) {
            for i in 0..<15 {
                if let date = calendar.date(byAdding: .day, value: 7*(i-14), to: lastMonday) {
                    last15recurrences.append(date)
//                    let previousDayCount = cumulativeCounts.last ?? 0
//                    if habit.completed.contains(where: { calendar.isDate(date, inSameDayAs: $0) }) { //completed on that day
//                        //+1
//                        let thisDayCount = previousDayCount+1
//                        cumulativeCounts.append(thisDayCount)
//                        temp.append(LineChartElement(date: date, value: thisDayCount))
//                    } else { //NOT completed on that day
//                        //-1
//                        let thisDayCount = max(previousDayCount-1, 0) //never goes under 0.
//                        cumulativeCounts.append(thisDayCount)
                        temp.append(LineChartElement(date: date, value: 0))
//                    }
                }
            }
        }

        data = temp
    }
}

struct LineChartElement: Identifiable {
    var id: UUID = UUID()
    let date: Date
    let value: Int
}
