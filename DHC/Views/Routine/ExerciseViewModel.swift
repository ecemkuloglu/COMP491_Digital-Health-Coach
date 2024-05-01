//
//  ExerciseViewModel.swift
//  DHC
//
//  Created by Lab on 24.04.2024.
//

import SwiftUI
import Combine
import Firebase
import HealthKit

class ExerciseViewModel: ObservableObject {
    @Published var selectedExerciseIndex = 0
    @Published var selectedMinutesIndex = 0
    @Published var selectedSecondsIndex = 0
    @Published var selectedDate: Date = Date()
    @Published var dailyExercises: [String] = []
    @Published var stepCount: Int = 0
    @Published var exercises: [String] = []
    private var healthStore = HKHealthStore()
    @Published var filteredExercises: [String] = []
    @Published var preferences: [String: String] = [:]

    let minutesRange = Array(0...60)
    let secondsRange = Array(0...59)

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchExercisesFromManager()
        fetchPreferencesAndFilterExercises()
    }

    private func fetchExercisesFromManager() {
        Task {
            do {
                let fetchedExercises = try await ExerciseManager.shared.getAllExercises()
                DispatchQueue.main.async {
                    self.exercises = fetchedExercises.map { $0.name }
                }
            } catch {
                print("Error fetching exercises: \(error)")
            }
        }
    }

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
                fetchExercisesForSelectedDate()
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
        fetchStepCount()
    }
    
    func fetchPreferencesAndFilterExercises() {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Error: User not logged in")
                return
            }
            PreferenceManager.shared.fetchAllPreferences(userId: userId) { [weak self] preferences, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching preferences: \(error.localizedDescription)")
                    return
                }
                self.preferences = preferences ?? [:]
                self.updateFilteredExercises()
            }
        }

        func updateFilteredExercises() {
            Task {
                do {
                    let matchedExercises = try await ExerciseManager.shared.fetchExercisesMatchingPreferences(preferences: self.preferences)
                    DispatchQueue.main.async {
                        self.filteredExercises = matchedExercises.map { $0.name }
                    }
                } catch {
                    print("Error fetching filtered exercises: \(error)")
                }
            }
        }
    
    func fetchStepCount() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Error fetching step count: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let count = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self.stepCount = count
            }
        }
        healthStore.execute(query)
    }
}
