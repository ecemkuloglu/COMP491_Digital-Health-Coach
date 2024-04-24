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
    private var healthStore = HKHealthStore()

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
        fetchStepCount()
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