//
//  ExerciseManager.swift
//  DHC
//
//  Created by Trio on 14.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExerciseManager {
    
    static let shared = ExerciseManager()
    private var db = Firestore.firestore()

    private init() {}
    
    func fetchExercises() async throws -> [ExerciseModel] {
            let snapshot = try await db.collection("exercises").getDocuments()
            let exercises = snapshot.documents.compactMap { doc -> ExerciseModel? in
                try? doc.data(as: ExerciseModel.self)
            }
            return exercises
        }
    
   
    func getAllExercises() async throws -> [ExerciseModel] {
            let querySnapshot = try await Firestore.firestore().collection("exercises").getDocuments()
            var exercises: [ExerciseModel] = []
            for document in querySnapshot.documents {
                let exercise = try document.data(as: ExerciseModel.self)
                exercises.append(exercise)
            }
            return exercises
        }

    func getExerciseByName(name: String) async throws -> ExerciseModel? {
        let querySnapshot = try await Firestore.firestore().collection("exercises").whereField("name", isEqualTo: name).getDocuments()
        guard let document = querySnapshot.documents.first else {
            throw ExerciseManagerError.exerciseNotFound
        }
        let data = document.data()
        guard let name = data["name"] as? String,
                let desc = data["desc"] as? String,
                let exp_before = data["exp_before"] as? String,
                let focus_area = data["focus_area"] as? String,
                let goal = data["goal"] as? String,
                let loc_preference = data["loc_preference"] as? String,
                let photo_url = data["photo_url"] as? String

        else {
            throw ExerciseManagerError.invalidData
        }
        return ExerciseModel(name: name, desc: desc,photo_url: photo_url, exp_before: exp_before, focus_area: focus_area, goal: goal, loc_preference: loc_preference)
    }
    
    func fetchExercisesMatchingPreferences(preferences: [String: String]) async throws -> [ExerciseModel] {
            var query: Query = db.collection("exercises")
            
            if let focusArea = preferences["focus_area_preference"] {
                query = query.whereField("focus_area", isEqualTo: focusArea)
            }
            if let goal = preferences["goal_preference"] {
                query = query.whereField("goal", isEqualTo: goal)
            }
            if let expBefore = preferences["exp_before_preference"] {
                query = query.whereField("exp_before", isEqualTo: expBefore)
            }
            if let locPreference = preferences["loc_preference"] {
                query = query.whereField("loc_preference", isEqualTo: locPreference)
            }

            let querySnapshot = try await query.getDocuments()
            var exercises: [ExerciseModel] = []
            for document in querySnapshot.documents {
                if let exercise = try? document.data(as: ExerciseModel.self) {
                    exercises.append(exercise)
                }
            }
            return exercises
            
        }
    
    enum ExerciseManagerError: Error {
        case invalidData
        case exerciseNotFound
        case fetchFailed
        
        var localizedDescription: String {
            switch self {
            case .invalidData:
                return "Invalid exercise data."
            case .exerciseNotFound:
                return "Exercise not found."
            case .fetchFailed:
                return "Failed to fetch exercises."
            }
        }
    }
}
