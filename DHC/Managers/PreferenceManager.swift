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

    func savePreference(userId: String, preferenceTitle: String, option: String, completion: @escaping (Bool, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let field = preferenceTitle.lowercased().replacingOccurrences(of: " ", with: "_") + "_preference"

        userRef.setData([field: option], merge: true) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

    func fetchUserPreference(userId: String, preferenceTitle: String, completion: @escaping (String?, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let field = preferenceTitle.lowercased().replacingOccurrences(of: " ", with: "_") + "_preference"

        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let document = documentSnapshot, document.exists, let data = document.data() {
                completion(data[field] as? String, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}
