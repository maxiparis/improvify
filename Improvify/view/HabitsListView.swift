//
//  ContentView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import SwiftUI
import SwiftData

struct HabitsListView: View {
    @Bindable var habitsManager: HabitsManager
    
    var body: some View {
        NavigationStack {
            //Main Content
            List {
                Section {
                    HStack {
                        
                        Image(systemName: "arrow.left").onTapGesture {
                            withAnimation {
                                habitsManager.moveDayBackward()
                            }
                        }
                        
                        
                        Spacer()
                        Text(habitsManager.dateString)
                            .font(.title3)
                            .onTapGesture {
                                withAnimation {
                                    habitsManager.goToToday()
                                }
                                
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
                
                //MARK: - List of Habits
                Section {
                    ForEach(habitsManager.habits) { habit in
                        HabitRow(habitsManager: habitsManager, habit: habit)
                    }
                    .onDelete(perform: habitsManager.handleOnDelete)
                }
            }
            
            .navigationTitle(Text("Improvify"))
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        habitsManager.presentAddHabitView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $habitsManager.presentAddHabitView) {
                AddHabitView(habitManager: habitsManager)
            }
            .sheet(isPresented: $habitsManager.presentEditHabitView) {
                EditHabitView(habitManager: habitsManager)
            }
            .navigationDestination(isPresented: $habitsManager.presentGraphView) {
                if let habitSelected = habitsManager.graphSelectedHabit {
                    HabitGraphView(manager: HabitGraphManager(habit: habitSelected))
                }
            }
        }
    }
}




struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {
            
            // 2
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                
                configuration.label
            }
        })
    }
}

struct HabitRow: View {
    var habitsManager: HabitsManager
    var habit: Habit
    @Environment(\.editMode) private var editMode

    
    var body: some View {
        HStack {
            Image(systemName: habitsManager.habitIsCompleted(habit) ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .onTapGesture {
                    if !editMode!.wrappedValue.isEditing {
                        withAnimation {
                            habitsManager.handleTappingOnHabit(habit)
                        }
                    }
                }
            
            Text("\(habit.name) - \(habit.completeBy)")
                .strikethrough(habitsManager.habitIsCompleted(habit))
                .foregroundStyle(habitsManager.habitIsCompleted(habit) ? .secondary : .primary)
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
