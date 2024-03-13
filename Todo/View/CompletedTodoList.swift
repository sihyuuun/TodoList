//
//  CompletedTodoList.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    @Binding var showAll: Bool
    @Query private var completedList: [Todo]
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            /// Limiting to 15
            descriptor.fetchLimit = 15
        }
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
    
    var body: some View {
        Section {
            ForEach(completedList) {
                TodoRowView(todo: $0)
            }
        } header: {
            HStack {
                Text("Completed")
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                if showAll && !completedList.isEmpty {
                    Button("Show Recent") {
                        showAll = false
                    }
                }
            }
        } footer: {
            if completedList.count == 15 && !showAll && !completedList.isEmpty {
                HStack {
                    Text("Showing Recent 15 Tasks")
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Button("Show All") {
                        showAll = true
                    }
                }
                .font(.caption)
            }
            
        }

    }
}

#Preview {
    CompletedTodoList(showAll: .constant(true))
}
