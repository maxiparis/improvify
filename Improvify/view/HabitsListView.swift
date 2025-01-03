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
                        HStack {
                            Image(systemName: habitsManager.habitIsCompleted(habit) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    withAnimation {
                                        habitsManager.handleTappingOnHabit(habit)
                                    }
                                }
                            
                            Text("\(habit.name) - \(habit.completeBy)")
                                .strikethrough(habitsManager.habitIsCompleted(habit))
                                .foregroundStyle(habitsManager.habitIsCompleted(habit) ? .secondary : .primary)
                                .onTapGesture {
                                    habitsManager.graphSelectedHabit = habit
                                    habitsManager.presentGraphView = true
                                }
                            
                            Spacer()
                            
                            Image(systemName: "pencil")
                                .onTapGesture {
                                    habitsManager.habitOnEdit = habit
                                    habitsManager.presentEditHabitView = true
                                    
                                }
                        }
                        
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
