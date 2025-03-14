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
    @State var showAlert = false
    @Environment(\.editMode) private var editMode
    var isEditing: Bool {
        editMode!.wrappedValue.isEditing
    }

    
    var body: some View {
        HStack {
            if editMode!.wrappedValue.isEditing {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .onTapGesture {
                        showAlert = true
                    }
                    .alert("Are you sure you want to delete this habit?", isPresented: $showAlert) {
                        Button("Delete", role: .destructive) {
                            withAnimation {
                                habitsManager.handleDelete(habit: habit)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .lineLimit(1)
                        .strikethrough(habitsManager.habitIsCompleted(habit, on: date))
                        .foregroundStyle(habitsManager.habitIsCompleted(habit, on: date) ? .secondary : .primary)
                    Text("\(habit.completeBy)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if !editMode!.wrappedValue.isEditing {
                    habitsManager.graphSelectedHabit = habit
                    habitsManager.presentGraphView = true
                }
            }
            
            
            Image(systemName: isEditing ? ("pencil.circle") : (habitsManager.habitIsCompleted(habit, on: date) ? "checkmark.circle.fill" : "circle"))
                .foregroundStyle(isEditing ? .blue : .orange)
                .font(.system(size: 20))
                .onTapGesture {
                    if isEditing {
                        habitsManager.habitOnEdit = habit
                        habitsManager.presentEditHabitView = true
                    } else {
                        withAnimation {
                            habitsManager.handleTappingOnHabitCheckmark(habit, on: date)
                        }
                    }
                }
        }
    }
}
