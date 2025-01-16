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
            InfinitePageView(selection: $habitsManager.dateSelected, before: habitsManager.previousDay, after: habitsManager.nextDay) { date in
                DateAndHabitsList(habitsManager: habitsManager, date: date)
            }
            .ignoresSafeArea(edges: .bottom)
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


struct InfinitePageView<C, T>: View where C: View, T: Hashable {
    @Binding var selection: T

    let before: (T) -> T
    let after: (T) -> T

    @ViewBuilder let view: (T) -> C

    @State private var currentTab: Int = 0

    var body: some View {
        let previousIndex = before(selection)
        let nextIndex = after(selection)
        
        TabView(selection: $currentTab) {
            view(previousIndex)
                .tag(-1)

            view(selection)
                .onAppear {
                    currentTab = 0
                }
                .onDisappear {
                    if currentTab != 0 {
                        selection = currentTab < 0 ? previousIndex : nextIndex
                        currentTab = 0
                    }
                }
                .tag(0)

            view(nextIndex)
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .onChange(of: selection) { _ in
//            currentTab = 0
//        }
        .onChange(of: selection) { _ , _ in
            currentTab = 0
        }
        .disabled(currentTab != 0) // Prevent double swiping issue
    }
}

struct DateAndHabitsList: View {
    var habitsManager: HabitsManager
    var date: Date
    
    var body: some View {
        VStack {
            Text("\(habitsManager.dateFormatter.string(from: date))")
                .padding()

            List(habitsManager.habits, id: \.self) { habit in
                
                Section {
                    ForEach(habitsManager.habits, id: \.self) {
                        HabitRow(habitsManager: habitsManager, habit: habit, date: date)
                        
                    }
                }
            }
        }
    }
}
