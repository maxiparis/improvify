//
//  HabitGraphView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/1/25.
//

import Charts
import SwiftUI

struct HabitGraphView: View {
    @Bindable var manager: HabitGraphManager
    
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
                AxisMarks(preset: .aligned, position: .leading, values: values)
                { value in
                    AxisValueLabel("\(values[value.index])").offset(x: -7)
                    AxisGridLine()
                }
            }
            .listRowBackground(Color.clear)
            .foregroundStyle(Color(.blue))
            .frame(height: 400)

        }
        .toolbar(content: {
            Button {
                manager.showPopover.toggle()
            } label: {
                HStack {
                    Image(systemName: "questionmark.circle")
                }
            }
            .listRowBackground(Color.clear)
            .popover(
                isPresented: $manager.showPopover,
                attachmentAnchor: .point(.leading),
                content: {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("How does this graph work?")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("""
                                At Improvify, we focus on progress, not streaks.
                                
                                The graph below shows your progress over the last 15 days. Each point represents a day or a week, depending on the habit type. When you complete your habit, the count increases by one. If you miss it, the count decreases by one.
                                
                                Focus on the direction of the graph! If it’s trending up, you’re improving 🎉. If it’s going down, reflect on your habits and look for ways to adjust 🔄.
                                """)
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true) // Needed to allow text wrapping.
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .frame(minHeight: 360, maxHeight: 400)
                    .presentationCompactAdaptation(.popover)
                }
            )
        })
        .navigationTitle(manager.habit.name.removingEmojis())
    }
}
