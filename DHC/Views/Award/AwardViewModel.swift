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
            let wallPushUp = exercises.filter { $0.exercise == "Wall Push-Up" }.count
            let smallSquats = exercises.filter { $0.exercise == "Small Squats" }.count
            let backLegRaise = exercises.filter { $0.exercise == "Back Leg Raise" }.count
            let flamingo = exercises.filter { $0.exercise == "Flamingo" }.count
            let hipFlex = exercises.filter { $0.exercise == "Hip Flex" }.count
            let stepOver = exercises.filter { $0.exercise == "Step Over" }.count
            let sitToStand = exercises.filter { $0.exercise == "Sit to Stand" }.count
            let toeStand = exercises.filter { $0.exercise == "Toe Stand" }.count
            let sideLeg = exercises.filter { $0.exercise == "Side Leg Raise" }.count
            let hamstringCurls = exercises.filter { $0.exercise == "Hamstring Curls" }.count
        
            
            if hamstringCurls == 3 || sitToStand == 3 ||  stepOver == 3{
                self.awards.append(Award(title: "Stronger Leg!", description: "You have stronger leg now. Keep it up!"))
            }
            if wallPushUp == 3 || walkingTheLineCount == 3 ||  flamingo == 3 || toeStand == 3 {
                self.awards.append(Award(title: "More Balanced!", description: "You are more balanced now. Keep it up!"))
            }
    
            if smallSquats == 3 || sideLeg == 3 {
                self.awards.append(Award(title: "The Form is Protected!", description: "You've kept your form. Keep it up!"))
            }
            if backLegRaise == 3 {
                self.awards.append(Award(title: "Stronger Back!", description: "You have stronger back muscles now. Keep it up!"))
            }
            if hipFlex == 3 {
                self.awards.append(Award(title: "Stress Relieved!", description: "Your stress is relieved. Keep it up!"))
            }
            
            if hamstringCurls > 3 || sitToStand > 3 ||  stepOver > 3{
                self.awards.append(Award(title: "Amazing Leg!", description: "You have powerful leg now. Keep it up!"))
            }
            
            if wallPushUp > 3 || walkingTheLineCount > 3 ||  flamingo > 3 {
                self.awards.append(Award(title: "Best Balanced Person!", description: "You are more balanced now. Keep it up!"))
            }
            
            if smallSquats > 3 {
                self.awards.append(Award(title: "Best Form!", description: "You've kept your form. Keep it up!"))
            }
            if backLegRaise > 3 {
                self.awards.append(Award(title: "Powerful Back!", description: "You have powerful back muscles now. Keep it up!"))
            }
            if hipFlex > 3 {
                self.awards.append(Award(title: "More Relaxed!", description: "Your stress is relieved more. Keep it up!"))
            }
            
            if !exercises.isEmpty {
                self.awards.append(Award(title: "First Exercise!", description: "Congratulations on completing your first exercise. Keep up the good work!"))
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
