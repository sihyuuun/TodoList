//
//  ContentView.swift
//  Todo
//
//  Created by 이시현 on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Todo List")
        }
    }
}

#Preview {
    ContentView()
}
