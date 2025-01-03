//
//  HabitGraphView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/1/25.
//

import SwiftUI
import Charts

let ZERO_VALUE_OFFSET: CGFloat = 150

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
                    .offset(y: manager.allDataValuesAre0 ? ZERO_VALUE_OFFSET : 0)
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
            .chartYAxis {
                let values0 = [0]
                let values = [0, 3, 6, 9, 12, 15]
                AxisMarks(values: manager.allDataValuesAre0 ? values0 : values) { value in
                    AxisValueLabel("\(values[value.index])").offset(x: 15, y: manager.allDataValuesAre0 ? ZERO_VALUE_OFFSET : 0)
                    AxisGridLine().offset(y: manager.allDataValuesAre0 ? ZERO_VALUE_OFFSET : 0)
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
