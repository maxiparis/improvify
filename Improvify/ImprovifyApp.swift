//
//  ImprovifyApp.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import SwiftUI
import SwiftData

@main
struct ImprovifyApp: App {
    
    let container: ModelContainer
    var viewModel: HabitsManager
    
    var body: some Scene {
        WindowGroup {
            HabitsListView(habitsManager: viewModel)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Habit.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
        
        viewModel = HabitsManager(modelContext: container.mainContext)
    }
}
