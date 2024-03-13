//
//  TodoApp.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
