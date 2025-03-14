//
//  AddHabitView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/31/24.
//

import SwiftUI

struct EditHabitView: View {
    @Bindable var habitManager: HabitsManager
    @Environment(\.editMode) private var editMode

    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit information")) {
                    TextField("Name", text: $habitManager.editHabitName)
                }
                
                Section(header: Text("Reminder at:")) {
                    DatePicker(
                        "Select Time",
                        selection: $habitManager.editHabitTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                }
            }
            .navigationTitle(Text("Edit Habit"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        habitManager.handleEditHabit()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        habitManager.presentEditHabitView = false
                    }
                }
            }
        }
    }
}
