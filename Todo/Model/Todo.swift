//
//  Todo.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    private(set) var taskID: String = UUID().uuidString   // to update the to-do state of the widgets
    var task: String
    var isCompleted: Bool = false
    var priority: Priority = Priority.normal
    var lastUpdated: Date = Date.now
    
    init(task: String,  priority: Priority) {
        self.task = task
        self.priority = priority
    }
}

// Priority Status
enum Priority: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    // Priority Color
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
    
    
}
