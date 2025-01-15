//
//  AddHabitView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import SwiftUI

struct AddHabitView: View {
    @Bindable var habitManager: HabitsManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit information")) {
                    TextField("Name", text: $habitManager.newHabitName)
                }
                
                Section(header: Text("Complete by:")) {
                    DatePicker(
                        "Select Time",
                        selection: $habitManager.newHabitTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
            }
            .navigationTitle(Text("Add Habit"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        habitManager.createNewHabit()
                    }
                    .disabled(habitManager.newHabitName.isEmpty)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        habitManager.presentAddHabitView = false
                    }
                }
            }
        }
        .onDisappear {
            habitManager.newHabitName = ""
        }
    }
}
