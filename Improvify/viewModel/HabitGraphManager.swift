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
    var last15days: [Date] = []
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()

        // Set the desired date format
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter
    }
    
    
    //MARK: - Init
    init(habit: Habit) {
        self.habit = habit
        generateData()
    }

    
    //MARK: - Utils
    func generateData() {
        let calendar = Calendar.current
        let today = Date()
        var cumulativeCounts: [Int] = []
        var temp: [LineChartElement] = []

        for i in 0..<15 {
            if let date = calendar.date(byAdding: .day, value: i-15, to: today) {
                last15days.append(date)
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
        data = temp
    }
}

struct LineChartElement: Identifiable {
    var id: UUID = UUID()
    let date: Date
    let value: Int
}
