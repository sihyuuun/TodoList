//
//  Home.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    /// Active Todo's
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy)
    private var activeList: [Todo]
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    var body: some View {
        List {
            Section("") {
                ForEach(activeList) {
                    TodoRowView(todo: $0)
                }
            }
            
            /// Completed List
            CompletedTodoList(showAll: $showAll)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    /// Creating an Empty Todo Task
                    let todo = Todo(task:"", priority: .normal)
                    /// Saving item into context
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
        
        var activeSelectionTitle: String {
            let count = activeList.count
            return count == 0 ? "Active" : "Active (\(count))"
        }
    }
}

#Preview {
    ContentView()
}
