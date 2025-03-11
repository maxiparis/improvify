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
                
                Picker("Recurrence", selection: $habitManager.newHabitRecurrence) {
                    ForEach(HabitRecurrence.allCases, id: \.self) { recurrence in
                        Text(recurrence.rawValue.capitalized(with: nil)).tag(recurrence)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                
                Section(header: Text("Habit information")) {
                    TextField("Name", text: $habitManager.newHabitName)
                }
                
                Section(header: Text("Reminder at:")) {
                    DatePicker(
                        "Select Time",
                        selection: $habitManager.newHabitTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                }
            }
            .navigationTitle(Text("Add Habit"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        habitManager.handleCreateNewHabit()
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
