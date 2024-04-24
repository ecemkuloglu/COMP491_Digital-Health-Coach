//
//  PreferenceViewModel.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import SwiftUI
import Firebase

class PreferenceViewModel: ObservableObject {
    @Published var userPreference: String?

    func fetchUserPreference(preferenceTitle: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        let field = "\(preferenceTitle.lowercased().replacingOccurrences(of: " ", with: "_"))_preference"

        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching preference: \(error.localizedDescription)")
                return
            }

            if let document = documentSnapshot, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self.userPreference = data?[field] as? String
                }
            } else {
                print("Document does not exist.")
            }
        }
    }

    func savePreference(preferenceTitle: String, option: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        let field = "\(preferenceTitle.lowercased().replacingOccurrences(of: " ", with: "_"))_preference"

        userRef.setData([field: option], merge: true) { error in
            if let error = error {
                print("Error saving preference for \(preferenceTitle): \(error.localizedDescription)")
            } else {
                print("Preference saved successfully for \(preferenceTitle): \(option)")
                DispatchQueue.main.async {
                    self.userPreference = option
                }
            }
        }
    }
}
