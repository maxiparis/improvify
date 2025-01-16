//
//  HabitRow.swift
//  Improvify
//
//  Created by Maximiliano Paris Gaete on 1/16/25.
//
import SwiftUI

struct HabitRow: View {
    var habitsManager: HabitsManager
    var habit: Habit
    var date: Date
    @Environment(\.editMode) private var editMode

    
    var body: some View {
        HStack {
            Image(systemName: habitsManager.habitIsCompleted(habit, on: date) ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .onTapGesture {
                    if !editMode!.wrappedValue.isEditing {
                        withAnimation {
                            habitsManager.handleTappingOnHabit(habit, on: date)
                        }
                    }
                }
            
            Text("\(habit.name) - \(habit.completeBy)")
                .strikethrough(habitsManager.habitIsCompleted(habit, on: date))
                .foregroundStyle(habitsManager.habitIsCompleted(habit, on: date) ? .secondary : .primary)
                .onTapGesture {
                    if !editMode!.wrappedValue.isEditing {
                        habitsManager.graphSelectedHabit = habit
                        habitsManager.presentGraphView = true
                    }
                }
            
            Spacer()
            
            if editMode!.wrappedValue.isEditing {
                Image(systemName: "pencil")
                    .onTapGesture {
                        habitsManager.habitOnEdit = habit
                        habitsManager.presentEditHabitView = true
                    }
            }
        }
    }
}
