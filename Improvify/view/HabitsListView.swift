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
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
                InfinitePageView(
                    selection: $habitsManager.dateSelected,
                    before: habitsManager.previousDay,
                    after: habitsManager.nextDay,
                    view: { date in
                        DateAndHabitsView(habitsManager: habitsManager, date: date)
                    },
                    currentTab: $habitsManager.currentTab
                )
//            .ignoresSafeArea(edges: .bottom) //This line introduced the bug where the arrows wouldn't work unless there were external arrows
            .navigationTitle("Improvify")
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
                    
                    Button {
                        habitsManager.goToToday()
                    } label: {
                        Text("Today")
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
//            .background(Color(UIColor.secondarySystemGroupedBackground))
            .background(Color("mainBackground"))
        }

        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                habitsManager.goToToday(todayAnimated: false)
            }
        })
        .onAppear {
            NotificationManager.requestAuthorization()
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

