//
//  UserManager.swift
//  DHC
//
//  Created by Trio on 12.03.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class UserManager {
    
    static let shared = UserManager()
    
    init() {}
    private let db = Firestore.firestore()
    func createUser(auth: AuthDataResultModel) async throws {
        
        let userData: [String: Any] = [
            "user_id": auth.uid,
            "email": auth.email ?? "",
            "photo_url": "",
            "username": auth.displayName ?? ""
            
        ]
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> UserModel {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String,
              let email = data["email"] as? String else {
            throw URLError(.badServerResponse)
            // Add error handling
        }
        
        let photoUrl = data["photo_url"] as? String ?? ""
        let username = data["username"] as? String
        return UserModel(userId: userId, email: email, photoUrl: photoUrl, username: username)
    }
    
    
    
    func updateUsername(userId: String, newUsername: String) async throws {
        do {
            let userRef = Firestore.firestore().collection("users").document(userId)
            try await userRef.updateData(["username": newUsername])
        } catch {
            throw UserManagerError.updateFailed(message: error.localizedDescription)
        }
    }
    
    func updateUserPhoto(userId: String, newPhotoURL: String) async throws {
        do {
            let userRef = Firestore.firestore().collection("users").document(userId)
            try await userRef.updateData(["photo_url": newPhotoURL])
        } catch {
            throw UserManagerError.updateFailed(message: error.localizedDescription)
        }
    }
    
    func fetchUserPreferences(userId: String) async throws -> [Preference] {
        // Access Firestore and get the user document
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()

        // Ensure the document has data and extract the preferences sub-field
        guard let data = snapshot.data(), let preferencesData = data["preferences"] as? [String: [String]] else {
            print("Invalid data received in fetchUserPreferences.")
            throw URLError(.badServerResponse)  // Using URLError for consistency with your example
        }
        print("after guard fetchUserPreferences")
        // Map the dictionary to an array of Preference structs
        let preferences = preferencesData.map { Preference(title: $0.key, options: $0.value) }
        return preferences
    }

    // Fetch user preferences
   /* func fetchUserPreferences(userId: String) async throws -> [Preference] {
        print("in fetchUserPreferences")
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let preferences = data["preferences"] as? [String: [String]] else {
            print("Invalid data received in fetchUserPreferences.")
            throw UserManagerError.invalidData
        }
        print("after guard fetchUserPreferences")
        return preferences.map { Preference(title: $0.key, options: $0.value) }
    }
    */
    // Update user preferences
   /* func updateUserPreferences(userId: String, preferences: [Preference]) async throws {
        let preferencesData = preferences.reduce(into: [String: [String]]()) { (dict, pref) in
            dict[pref.title] = pref.options
        }
        do {
            let userRef = Firestore.firestore().collection("users").document(userId)
            try await userRef.updateData(["preferences": preferencesData])
        } catch {
            throw UserManagerError.updateFailed(message: error.localizedDescription)
        }
    }*/
    
    /*func fetchUserPreference(preferenceTitle: String) -> String {
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
                
                return userPreference = data?[field] as? String
                
            } else {
                print("Document does not exist.")
            }
        }
    }*/
    
    enum UserManagerError: Error {
        case invalidUserId
        case invalidData
        case updateFailed(message: String)
        
        var localizedDescription: String {
            switch self {
            case .invalidUserId:
                return "Invalid user ID."
            case .invalidData:
                return "Invalid data received."
            case .updateFailed(let message):
                return "Failed to update user: \(message)"
            }
        }
    }
}
