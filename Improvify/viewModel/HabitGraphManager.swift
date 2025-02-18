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
    var showPopover = false

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

    func lastWeekStartDay(using calendar: Calendar = .current) -> Date? {
        let firstWeekday = calendar.firstWeekday
        let today = calendar.startOfDay(for: Date()) // Normalize today
        let weekday = calendar.component(.weekday, from: today)
        
        // If today is monday, return today
        if weekday == firstWeekday {
            return today
        }
        
        return calendar.nextDate(after: today, matching: DateComponents(weekday: firstWeekday), matchingPolicy: .previousTimePreservingSmallerComponents, direction: .backward)
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
        if let lastWeekStartDay = lastWeekStartDay(using: calendar) {
            for i in 0..<15 {
                
                if let recurrentWeekStartDay = calendar.date(byAdding: .weekOfYear, value: i-14, to: lastWeekStartDay){
                    last15recurrences.append(recurrentWeekStartDay)
                    
                    let previousWeekCount = cumulativeCounts.last ?? 0
                    
                    if habit.completed.contains(where: { date in
                        calendar.isDate(date, equalTo: recurrentWeekStartDay, toGranularity: .weekOfYear)
                    }) {
                        //+1
                        let thisWeekCount = previousWeekCount+1
                        cumulativeCounts.append(thisWeekCount)
                        data.append(LineChartElement(date: recurrentWeekStartDay, value: thisWeekCount))
                    } else { //NOT completed on that week
                        //-1
                        let thisDayCount = max(previousWeekCount-1, 0) //Never goes under 0
                        cumulativeCounts.append(thisDayCount)
                        data.append(LineChartElement(date: recurrentWeekStartDay, value: 0))
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
