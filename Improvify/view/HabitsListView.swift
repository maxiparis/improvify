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
            ZStack {
                
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
                                Image(systemName: habitsManager.habitIsCompleted(habit) ? "checkmark.square" : "square")
                                    .font(.system(size: 25))
                                    .onTapGesture {
                                        withAnimation {
                                            habitsManager.handleTappingOnHabit(habit)
                                        }
                                    }
                                
                                Text("\(habit.name) - \(habit.completeBy)")
                                    .strikethrough(habitsManager.habitIsCompleted(habit))
                                    .foregroundStyle(habitsManager.habitIsCompleted(habit) ? .secondary : .primary)
                                    .onTapGesture {
                                        //TODO: open graph
                                    }
                                
                                Spacer()
                                
                                Image(systemName: "pencil")
                                    .onTapGesture {
                                        //TODO: edit
                                        habitsManager.habitOnEdit = habit
                                        habitsManager.presentEditHabitView = true

                                    }
                            }
                            
                        }
                        .onDelete(perform: habitsManager.handleOnDelete)
                        //                        .onMove(perform: habitsManager.handleOnMove)
                    }
                }

                
                // Phrase
                
                VStack {
                    Spacer()
                    VStack {
                        Text("Habit is the intersection of knowledge (what to do), skill (how to do), and desire (want to do).")
                            .padding(.horizontal, 20)
                        HStack {
                            Spacer()
                            Text("- Stephen R. Covey")
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.secondary.opacity(0.1))
                    }
                }
                .foregroundStyle(.secondary)
                .padding()
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
