//
//  ExerciseDoneManager.swift
//  DHC
//
//  Created by Lab on 24.04.2024.
//

import Foundation
import Firebase

class ExerciseDoneManager {
    static let shared = ExerciseDoneManager()
    private let database = Firestore.firestore()
    
    private func userExercisesReference(userId: String) -> CollectionReference {
        return database.collection("users").document(userId).collection("exercises")
    }
    
    func saveExercise(userId: String, exercise: String, duration: Int, date: Date) async throws {
        let data: [String: Any] = [
            "exercise": exercise,
            "duration": duration,
            "date": Timestamp(date: date)
        ]
        
        do {
            _ = try await userExercisesReference(userId: userId).addDocument(data: data)
        } catch {
            print("Error saving exercise to Firestore: \(error)")
            throw error
        }
    }
    
    func fetchExercises(userId: String, date: Date) async throws -> [ExerciseRecordModel] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let querySnapshot = try await userExercisesReference(userId: userId)
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("date", isLessThan: Timestamp(date: endOfDay))
            .getDocuments()
        
        return querySnapshot.documents.compactMap { document -> ExerciseRecordModel? in
            let data = document.data()
            guard let exercise = data["exercise"] as? String,
                  let duration = data["duration"] as? Int,
                  let date = (data["date"] as? Timestamp)?.dateValue() else {
                return nil
            }
            return ExerciseRecordModel(exercise: exercise, duration: duration, date: date)
        }
    }
    func fetchAllExercises() async throws -> [ExerciseRecordModel] {
        
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "There is no user with this username."])
            
        }
        
        let userId = currentUser.uid
        
        let querySnapshot = try await userExercisesReference(userId: userId)
            .getDocuments()
        
        var allExercises: [ExerciseRecordModel] = []
        
        querySnapshot.documents.forEach { document in
            let data = document.data()
            if let exercise = data["exercise"] as? String,
               let duration = data["duration"] as? Int,
               let date = (data["date"] as? Timestamp)?.dateValue() {
                let exerciseRecord = ExerciseRecordModel(exercise: exercise, duration: duration, date: date)
                
                allExercises.append(exerciseRecord)         
            }
   
        }
        return allExercises
        
    }
}


