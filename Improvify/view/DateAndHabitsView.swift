//
//  DateAndHabitsView.swift
//  Improvify
//
//  Created by Maximiliano Paris Gaete on 1/16/25.
//
import SwiftUI

struct DateAndHabitsView: View {
    var habitsManager: HabitsManager
    var date: Date
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "arrow.left")
                        .onTapGesture {
                            withAnimation {
                                habitsManager.moveDayBackward()
                            }
                        }
                    
                    Spacer()
                    Text("\(habitsManager.dateFormatter.string(from: date))")
                        .onTapGesture {
                            habitsManager.goToToday()
                        }
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .onTapGesture {
                            withAnimation {
                                habitsManager.moveDayForward()
                            }
                        }
                }
            }
            
            Section {
                ForEach(habitsManager.habits, id: \.self) { habit in
                    HabitRow(habitsManager: habitsManager, habit: habit, date: date)
                }
            }
        }
    }
}
