//
//  ExerciseViewModel.swift
//  DHC
//
//  Created by Lab on 24.04.2024.
//

import SwiftUI
import Combine
import Firebase

class ExerciseViewModel: ObservableObject {
    @Published var selectedExerciseIndex = 0
    @Published var selectedMinutesIndex = 0
    @Published var selectedSecondsIndex = 0
    @Published var selectedDate: Date = Date()
    @Published var dailyExercises: [String] = []

    let exercises = ["Push-ups", "Running", "Swimming", "Cycling"]
    let minutesRange = Array(0...60)
    let secondsRange = Array(0...59)

    private var cancellables = Set<AnyCancellable>()

    func saveExercise() {
        let exercise = exercises[selectedExerciseIndex]
        let durationMinutes = minutesRange[selectedMinutesIndex]
        let durationSeconds = secondsRange[selectedSecondsIndex]
        let totalDuration = durationMinutes * 60 + durationSeconds  

        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in")
            return
        }

        Task {
            do {
                try await ExerciseDoneManager.shared.saveExercise(
                    userId: userId,
                    exercise: exercise,
                    duration: totalDuration,
                    date: selectedDate
                )
                print("Exercise saved successfully.")
                await fetchExercisesForSelectedDate()
            } catch {
                print("Error saving exercise: \(error)")
            }
        }
    }

    func fetchExercisesForSelectedDate() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in")
            return
        }

        Task {
            do {
                let exercises = try await ExerciseDoneManager.shared.fetchExercises(userId: userId, date: selectedDate)
                DispatchQueue.main.async {
                    self.dailyExercises = exercises.map { "\($0.exercise) for \($0.duration / 60) min \($0.duration % 60) sec" }
                }
            } catch {
                print("Error fetching exercises: \(error)")
            }
        }
    }
}
