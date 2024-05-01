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
        let field = fieldName(from: preferenceTitle)

        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(false, error)
                return
            }

            if let document = documentSnapshot, document.exists, let data = document.data() {
                if let currentPreference = data[field] as? String, currentPreference == option {
                    completion(true, nil)
                } else {
                    userRef.setData([field: option], merge: true) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }

    func fetchUserPreference(userId: String, preferenceTitle: String, completion: @escaping (String?, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let field = fieldName(from: preferenceTitle)

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
    
    func fetchAllPreferences(userId: String, completion: @escaping ([String: String]?, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        var preferences: [String: String] = [:]
        
        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching preferences: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist for user: \(userId)")
                completion(nil, nil)
                return
            }
            if let data = document.data() {
                for (key, value) in data {
                    let processedKey = key.components(separatedBy: "_preference").first! + "_preference"
                    if let preference = value as? String {
                        preferences[processedKey] = preference
                    }
                }
                completion(preferences, nil)
            } else {
                print("No data available on document.")
                completion(nil, nil)
            }
        }
    }
    func fieldName(from title: String) -> String {
        let processedTitle = title.lowercased().replacingOccurrences(of: " ", with: "_")
        if processedTitle.hasSuffix("_preference") {
            return processedTitle
        } else {
            return processedTitle + "_preference"
        }
    }
}
