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
            
            Section {
                if habitsManager.habits.isEmpty {
                    Text("No habits yet. Add one by tapping the plus button above.")
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(habitsManager.habits, id: \.self) { habit in
                        HabitRow(habitsManager: habitsManager, habit: habit, date: date)
                    }
                }
            }
        }
    }
}
