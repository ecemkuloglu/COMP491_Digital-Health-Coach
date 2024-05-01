//
//  BalanceManager.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//
import Foundation
import Firebase

class BalanceManager {
    static let shared = BalanceManager() // Singleton instance for easy access

    private let db = Firestore.firestore()

    func saveGyroscopeData(x: Double, y: Double, z: Double) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let gyroscopeData: [String: Any] = [
            "x": x,
            "y": y,
            "z": z,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userID).collection("gyroscopeData").addDocument(data: gyroscopeData) { error in
            if let error = error {
                print("Error saving gyroscope data: \(error.localizedDescription)")
            } else {
                print("Gyroscope data successfully saved.")
            }
        }
    }
}
