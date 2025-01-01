//
//  HabitGraphView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 1/1/25.
//

import SwiftUI
import Charts

struct HabitGraphView: View {
    
    var body: some View {
        List {
            Chart {
                LineMark(
                    x: .value("Date", Date()),
                    y: .value("Count", 2)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .frame(width: 12, height: 12)
                }
                
                LineMark(
                    x: .value("Date", Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
                    y: .value("Count", 3)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .frame(width: 12, height: 12)
                }
                
                LineMark(
                    x: .value("Date", Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
                    y: .value("Count", 3)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .frame(width: 12, height: 12)
                }
                
                LineMark(
                    x: .value("Date", Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
                    y: .value("Count", 4)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .frame(width: 12, height: 12)
                }
            }
            .listRowBackground(Color.clear)
            .foregroundStyle(Color(.blue))
            .frame(height: 300)
            .padding()
            
        }
        .navigationTitle("Report")
        
    }
}
