//
//  HabitGraphView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/1/25.
//

import SwiftUI
import Charts

struct HabitGraphView: View {
    var manager: HabitGraphManager
    
    var body: some View {
        List {
            Chart {
                ForEach(manager.data) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Count", $0.value)
                    )
                    .symbol {
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Date").padding(.top, 5)
            }
            .chartYAxisLabel("Cumulative Count", position: .leading)
            .chartXAxis {
                AxisMarks(preset: .aligned , values: manager.last15recurrences) { value in
                    if ((value.index) % 3 == 0 || value.index == 0 || value.index == value.count-1) {
                        let date = manager.last15recurrences[value.index]
                        let stringFormatted = manager.formatter.string(from: date)
                        AxisValueLabel(stringFormatted)
                            .offset(y: 10)
                    }
                    AxisGridLine()
                }
            }
            .chartYScale(domain: 0...15)
            .chartYAxis {
                let values = [0, 3, 6, 9, 12, 15]
                AxisMarks(preset: .aligned, position: .leading, values: values) { value in
                    AxisValueLabel("\(values[value.index])").offset(x: -7)
                    AxisGridLine()
                }
            }
            .listRowBackground(Color.clear)
            .foregroundStyle(Color(.blue))
            .frame(height: 400)
            
        }
        .navigationTitle(manager.habit.name.removingEmojis())
    }
}
