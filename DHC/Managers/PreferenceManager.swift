//
//  PreferenceManager.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import Foundation
import Firebase

class PreferenceManager {
    static let shared = PreferenceManager()
    private let db = Firestore.firestore()

    func savePreference(preferenceTitle: String, option: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }

        let userRef = db.collection("users").document(userId)
        let field = preferenceTitle.lowercased().replacingOccurrences(of: " ", with: "_") + "_preference"

        userRef.setData([field: option], merge: true) { error in
            if let error = error {
                print("Error saving preference for \(preferenceTitle): \(error.localizedDescription)")
            } else {
                print("Preference saved successfully for \(preferenceTitle): \(option)")
            }
        }
    }
}
