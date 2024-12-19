//
//  HabitsManager.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import Foundation
import SwiftData

@Observable
class HabitsManager {
    
    //MARK: - Properties
    private var modelContext: ModelContext
    

    
    //MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
}
