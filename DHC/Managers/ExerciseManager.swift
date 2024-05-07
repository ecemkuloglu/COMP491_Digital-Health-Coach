//
//  ExerciseManager.swift
//  DHC
//
//  Created by Trio on 14.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import HealthKit

class ExerciseManager {
    
    static let shared = ExerciseManager()
    private var db = Firestore.firestore()
    private var healthStore = HKHealthStore()
    

    private init() {
        requestHealthKitPermissions()
    }
    
    private func requestHealthKitPermissions() {
            let healthKitTypesToRead: Set<HKObjectType> = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.workoutType()
            ]
            
            let healthKitTypesToWrite: Set<HKSampleType> = [
                HKObjectType.workoutType()
            ]

            healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { success, error in
                if !success {
                    // Handle the error here.
                    print("HealthKit Authorization Failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    
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
    
    func fetchStepCountForDate(date: Date, completion: @escaping (Int?, Error?) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "HKError", code: 0, userInfo: [NSLocalizedDescriptionKey: "HealthKit Step Count Type not available."]))
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
            } else if let result = result, let sum = result.sumQuantity() {
                let steps = Int(sum.doubleValue(for: HKUnit.count()))
                completion(steps, nil)
            }
        }

        healthStore.execute(query)
    }
    
    func saveExerciseWithData(exercise: ExerciseModel, healthData: [String: Any]) async throws {
        var data = try Firestore.Encoder().encode(exercise)
        data["steps"] = healthData["steps"]
        data["caloriesBurned"] = healthData["calories"]

        let exerciseRef = Firestore.firestore().collection("exercises")
        let documentRef = try await exerciseRef.addDocument(data: data)  // Store the reference
        print("Exercise saved with document ID: \(documentRef.documentID)")
    }

    
}
