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
                        .font(.system(size: 20))
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            withAnimation {
                                habitsManager.moveDayBackward()
                            }
                        }
                    
                    Spacer()
                    Text("\(date.toDateString())")
                        .font(.headline)
                        .scaleEffect(habitsManager.isDateAnimating ? 1.2 : 1.0) // Increase size to 1.5x
                        .onTapGesture {
                            habitsManager.goToToday()
                        }
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            withAnimation {
                                habitsManager.moveDayForward()
                            }
                        }
                }
            }
            
            if habitsManager.dailyHabits.isEmpty && habitsManager.weeklyHabits.isEmpty {
                Text("There are no habits for this day. Create one by tapping on the plus (+) button in the top right corner.")
                    .listRowBackground(Color.clear)
            } else {
                if (!habitsManager.dailyHabits.isEmpty) {
                    Section(header: Text("Daily Habits")) {
                        ForEach(habitsManager.dailyHabits, id: \.self) { habit in
                            HabitRow(habitsManager: habitsManager, habit: habit, date: date)
                        }
                    }
                }
                
                if (!habitsManager.weeklyHabits.isEmpty) {
                    Section(header: Text("Weekly habits")) {
                        ForEach(habitsManager.weeklyHabits, id: \.self) { habit in
                            HabitRow(habitsManager: habitsManager, habit: habit, date: date)
                        }
                    }
                }
            }
        }
    }
}
