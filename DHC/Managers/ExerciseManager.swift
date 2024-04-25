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
    
    private init() {}
    
    func getAllExercises() async throws -> [ExerciseModel] {
        let querySnapshot = try await Firestore.firestore().collection("exercises").getDocuments()
        var exercises: [ExerciseModel] = []
        for document in querySnapshot.documents {
            let data = document.data()
            guard let name = data["name"] as? String,
                  let desc = data["desc"] as? String,
                  let photoUrl = data["photo_url"] as? String else {
                throw ExerciseManagerError.invalidData
            }
            let exercise = ExerciseModel(name: name, desc: desc, photoUrl: photoUrl)
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
              let photoUrl = data["photo_url"] as? String else {
            throw ExerciseManagerError.invalidData
        }
        return ExerciseModel(name: name, desc: desc, photoUrl: photoUrl)
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


