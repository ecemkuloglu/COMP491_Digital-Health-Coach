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
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }

        PreferenceManager.shared.fetchUserPreference(userId: userId, preferenceTitle: preferenceTitle) { preference, error in
            if let error = error {
                print("Error fetching preference: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.userPreference = preference
            }
        }
    }

    func savePreference(preferenceTitle: String, option: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }

        PreferenceManager.shared.savePreference(userId: userId, preferenceTitle: preferenceTitle, option: option) { success, error in
            if let error = error {
                print("Error saving preference for \(preferenceTitle): \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.userPreference = option
            }
        }
    }
}
