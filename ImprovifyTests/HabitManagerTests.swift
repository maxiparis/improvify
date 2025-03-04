//
//  HabitViewModelTests.swift
//  ImprovifyTests
//
//  Created by Maximiliano París Gaete on 2/26/25.
//

import XCTest
@testable import Improvify
import SwiftData

final class HabitViewModelTests: XCTestCase {

    @MainActor func testCreatingHabits() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)

        let vm = HabitsManager(modelContext: container.mainContext)
                
        XCTAssertEqual(0, vm.dailyHabits.count, "Daily habits should be empty")
        XCTAssertEqual(0, vm.weeklyHabits.count, "Weekly habits should be empty")
        
        let components = DateComponents(hour: 17)
        let date = Calendar.current.date(from: components)
        
        guard let date else { return }
        
        vm.createHabit(Habit(name: "Do Homework", completeByDate: date, recurrence: HabitRecurrence.daily.rawValue))
        
        XCTAssertTrue(vm.dailyHabits.contains(where: { $0.name == "Do Homework" }), "Created habit does not exists on daily habits" )
        XCTAssertEqual(0, vm.weeklyHabits.count, "Weekly habits should be empty even after creating a daily habit")
        
    }

}
