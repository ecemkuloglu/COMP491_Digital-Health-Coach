//
//  SearchViewModel.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var exercises: [ExerciseModel] = []
    @Published var isLoading = false

    private var exerciseManager = ExerciseManager.shared

    func loadExercises() {
            isLoading = true
            Task {
                do {
                    let fetchedExercises = try await exerciseManager.getAllExercises()
                    DispatchQueue.main.async {
                        self.exercises = fetchedExercises
                        self.isLoading = false
                    }
                } catch {
                    print("Error loading exercises: \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
        }
}
