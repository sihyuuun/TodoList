//
//  TodoRowView.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    @Bindable var todo: Todo
    /// View Properties
    @FocusState var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    var body: some View {
        HStack(spacing: 8) {
            if !isActive && !todo.task.isEmpty {
                Button(action: {
                    todo.isCompleted.toggle()
                    todo.lastUpdated = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : .primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            TextField("Record video", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isActive)
            
            if !isActive && !todo.task.isEmpty {
                /// Priority Menu Button (For Updating)
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: {todo.priority = priority}, label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priority == priority { Image(systemName: "checkmark")}
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
            
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = todo.task.isEmpty
        }
        /// Swipe to Delete
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
                /// Deleting Empty Todo
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != oldValue && todo.task.isEmpty {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            todo.isCompleted = todo.isCompleted
        }
    }
}

#Preview {
    ContentView()
}
