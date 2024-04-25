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
    
    /*func getExercisesMatchingPreferences(preferences: [Preference]) async throws -> [ExerciseModel] {
        let db = Firestore.firestore()
        var query: Query = db.collection("exercises")

        // Example: Adding a simple preference filter for 'focus_area'
        if let focusAreaPreference = preferences.first(where: { $0.title == "Focus Area" }) {
            query = query.whereField("focus_area", isEqualTo: focusAreaPreference.options.first ?? "")
        }
        if let goal = preferences.first(where: { $0.title == "Goal" }) {
               query = query.whereField("goal", isEqualTo: goal)
           }
        if let location = preferences.first(where: { $0.title == "Location" }) {
               query = query.whereField("loc_preference", isEqualTo: location)
           }
        if let exp_before = preferences.first(where: { $0.title == "Experience Before" }) {
               query = query.whereField("exp_before", isEqualTo: exp_before)
           }
        
        let querySnapshot = try await query.getDocuments()
        return querySnapshot.documents.compactMap { document in
            try? document.data(as: ExerciseModel.self)
        }
    }*/
    
    func fetchExercises() async throws -> [ExerciseModel] {
            let snapshot = try await db.collection("exercises").getDocuments()
            let exercises = snapshot.documents.compactMap { doc -> ExerciseModel? in
                try? doc.data(as: ExerciseModel.self)
            }
            return exercises
        }
    
    /*func fetchExercisesMatchingAnyUserPreference(userPreferences: [Preference]) async throws -> [ExerciseModel] {
        print("in fetchExercisesMatchingAnyUserPreference")
        
            let allExercises = try await getAllExercises() // Fetch all exercises
            return allExercises.filter { exercise in
                // Check if any user preference matches any exercise attribute
                userPreferences.contains { preference in
                    preference.options.contains { option in
                        option == exercise.focus_area ||
                        option == exercise.goal ||
                        option == exercise.exp_before ||
                        option == exercise.loc_preference
                    }
                }
            }
        }*/
    
    /*func getAllExercises() async throws -> [ExerciseModel] {
        let querySnapshot = try await Firestore.firestore().collection("exercises").getDocuments()
        var exercises: [ExerciseModel] = []
        
        for document in querySnapshot.documents {
            let data = document.data()
            print("before guard")
            guard let name = data["name"] as? String,
                    let desc = data["desc"] as? String,
                    let exp_before = data["exp_before"] as? String,
                    let focus_area = data["focus_area"] as? String,
                    let goal = data["goal"] as? String,
                    let loc_preference = data["loc_preference"] as? String,
                    let photoUrl = data["photoUrl"] as? String
                    
            else {
                throw ExerciseManagerError.invalidData
            }
            print("after guard")
            let exercise = ExerciseModel(name: name, desc: desc, photoUrl: photoUrl, exp_before: exp_before, focus_area: focus_area, goal: goal, loc_preference: loc_preference)
            exercises.append(exercise)
        }
        print(exercises.count)
        print(exercises.first?.name ?? "empty")
        return exercises
    }*/
    func getAllExercises() async throws -> [ExerciseModel] {
            let querySnapshot = try await Firestore.firestore().collection("exercises").getDocuments()
            var exercises: [ExerciseModel] = []
            for document in querySnapshot.documents {
                let exercise = try document.data(as: ExerciseModel.self)
                exercises.append(exercise)
            }
            return exercises
        }
    /*func getAllExercises() async throws -> [ExerciseModel] {
        let querySnapshot = try await Firestore.firestore().collection("exercises").getDocuments()
        var exercises: [ExerciseModel] = []
        for document in querySnapshot.documents {
            let data = document.data()
            print("Fetched data: \(data)")
            // Ensure all required fields are present
            if let name = data["name"] as? String,
               let desc = data["desc"] as? String,
               let exp_before = data["exp_before"] as? String,
               let focus_area = data["focus_area"] as? String,
               let goal = data["goal"] as? String,
               let loc_preference = data["loc_preference"] as? String,
               let photoUrl = data["photoUrl"] as? String
                
            {
                print("after guard")
                let exercise = ExerciseModel(name: name, desc: desc, photoUrl: photoUrl, exp_before: exp_before, focus_area: focus_area, goal: goal, loc_preference: loc_preference)
                exercises.append(exercise)
            } else {
                print("Invalid : \(data)")
                throw ExerciseManagerError.invalidData
            }
        }
        return exercises
    }*/


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


