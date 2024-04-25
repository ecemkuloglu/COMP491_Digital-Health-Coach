//
//  SearchView.swift
//  DHC
//
//  Created by Aylin Melek on 21.03.2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var body: some View {
        VStack {
            // Title
            Text("EXERCISES")
                .font(.headline)
                .padding()
            
            List(viewModel.exercises, id: \.name) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.headline)
                    Text("Goal: \(exercise.goal)")
                        .font(.subheadline)
                    Text("Focus Area: \(exercise.focus_area)")
                        .font(.subheadline)
                    Text("Description: \(exercise.desc)")
                        .font(.subheadline)
                }
            }
            .onAppear {
                viewModel.loadExercises()
            }
        }
        .navigationBarItems(trailing:
                                Button(action: {
                                    // action
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title)
                                }
        )
    }
}
