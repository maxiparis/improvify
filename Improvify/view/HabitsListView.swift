//
//  ContentView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import SwiftUI
import SwiftData

struct HabitsListView: View {
    var habitsManager: HabitsManager
    
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
                                Image(systemName: habitsManager.habitIsCompleted(habit, on: habitsManager.dateSelected) ? "checkmark.square" : "square")
                                Text(habit.name)
                            }
                            .onTapGesture {
                                withAnimation {
                                    habitsManager.handleTappingOnHabit(habit)
                                }
                            }
                        }
                    }
                }
                
                // Phrase
                VStack {
                    Spacer()
                    Text("Habit is the intersection of knowledge (what to do), skill (how to do), and desire (want to do).")
                        .padding()
                    HStack {
                        Spacer()
                        Text("- Stephen R. Covery")
                    }
                    .padding()
                }
                .padding()
                
            }
            .navigationTitle(Text("Improvify"))
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
