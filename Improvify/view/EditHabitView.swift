//
//  AddHabitView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/31/24.
//

import SwiftUI

struct EditHabitView: View {
    @Bindable var habitManager: HabitsManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit information")) {
                    TextField("Name", text: $habitManager.editHabitName)
                }
                
                Section(header: Text("Complete by:")) {
                    DatePicker(
                        "Select Time",
                        selection: $habitManager.editHabitTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
            }
            .navigationTitle(Text("Edit Habit"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        //TODO: work on here
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
