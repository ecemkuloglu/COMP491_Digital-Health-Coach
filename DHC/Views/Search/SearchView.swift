//
//  SearchView.swift
//  DHC
//
//  Created by Aylin Melek on 21.03.2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: .zero) {
            Text("Exercises").font(.title)
            if viewModel.isLoading {
                LoadingView()
            } else {
                searchBar
                listView
            }
        }
        .onAppear {
            viewModel.loadExercises()
        }
       // .navigationTitle("Exercises")
    }
    
    private var searchBar: some View {
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(Spacing.spacing_1)
    }
    
    
    private var listView: some View {
        List(searchResults, id: \.name) { exercise in
            NavigationLink(destination: SearchDetailedView(exercise: exercise)){
                SearchListRow(exercise: exercise)
            }
        }
        .padding(Spacing.spacing_2)
    }
    
    var searchResults: [ExerciseModel] {
        if searchText.isEmpty {
            return viewModel.exercises
        } else {
            return viewModel.exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

