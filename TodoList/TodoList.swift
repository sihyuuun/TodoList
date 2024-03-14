//
//  TodoList.swift
//  TodoList
//
//  Created by 이시현 on 3/14/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TodoListEntryView : View {
    var entry: Provider.Entry
    /// Query that will fetch only three active todo at a time
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    
    var body: some View {
        VStack {
            ForEach(activeList) { todo in
                HStack(spacing: 10) {
                    /// Intent Action Button
                    Button(intent: ToggleButton(id: todo.taskID)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }}
            .transition(.push(from: .bottom))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Tasks 🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TodoList: Widget {
    let kind: String = "TodoList"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TodoListEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
            /// Setting up SwiftData Container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}


#Preview(as: .systemSmall) {
    TodoList()
} timeline: {
    SimpleEntry(date: .now)
}

/// Button Intent Which Will Update the todo status
struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        /// Updating Todo Status
        let context = try ModelContext( .init(for: Todo.self))
        
        /// Retreiving Respective Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskID == id })
        if let todo = try   context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            /// Saving Context
            try context.save()
        }
        return .result()
    }
}
