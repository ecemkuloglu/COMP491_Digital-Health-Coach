//
//  AwardViewModel.swift
//  DHC
//
//  Created by Lab on 26.04.2024.
//

import Foundation
import SwiftUI
import Firebase

// Award Model

struct Award {
    let title: String
    let description: String
    
}
class AwardViewModel: ObservableObject {
    @Published var awards: [Award] = [] {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    func updateAwards(exercises: [ExerciseRecordModel]) {
        DispatchQueue.main.async {
            self.awards.removeAll()
            let walkingTheLineCount = exercises.filter { $0.exercise == "Walking the Line" }.count
            // Check if there are 3 or more exercises named "Walking the Line"
            if walkingTheLineCount >= 3 {
                self.awards.append(Award(title: "Increasing Balance with Walking Line", description: "You've demonstrated great balance with walking in the line. Keep it up!"))
            }
            if !exercises.isEmpty {
                self.awards.append(Award(title: "You completed your first exercise!", description: "Congratulations on completing your first exercise. Keep up the good work!"))
            }
        }
    }
    
    func fetchAllExercises() async throws -> [ExerciseRecordModel] {
        return try await ExerciseDoneManager.shared.fetchAllExercises()
    }
    
    func updateAwards() async {
        do {
            let exercises = try await fetchAllExercises()
            updateAwards(exercises: exercises)
        } catch {
            print("Error fetching exercises: \(error)")
        }
    }
}
