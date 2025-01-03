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
                ForEach(manager.data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Count", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    //                    .lineStyle(.init(lineWidth: 2))
                    //                    .symbol {
                    //                        Circle()
                    //                            .frame(width: 12, height: 12)
                    //                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: manager.last15days) { value in
                    if (value.index % 3 == 0) {
                        let date = manager.last15days[value.index]
                        let stringFormatted = manager.formatter.string(from: date)
                        AxisValueLabel(stringFormatted)
                    }
                }
            }
            .chartYAxis {
                if manager.data.last?.value == 0 {
                    AxisMarks(values: [0]) //TODO: fix here
                } else {
                    AxisMarks(values: [0, 3, 6, 9, 12, 15])
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
