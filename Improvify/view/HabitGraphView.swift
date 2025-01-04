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
                            .frame(width: 5, height: 5)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned , values: manager.last15days) { value in
                    if ((value.index+1) % 3 == 0 || value.index == 0) {
                        let date = manager.last15days[value.index]
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
                AxisMarks(values: values) { value in
                    AxisValueLabel("\(values[value.index])").offset(x: 15)
                    AxisGridLine()
                }
            }
            .listRowBackground(Color.clear)
            .foregroundStyle(Color(.blue))
            .frame(height: 300)
            .padding()
            
        }
        .navigationTitle(manager.habit.name)
    }
}
