//
//  UserManager.swift
//  DHC
//
//  Created by Trio on 12.03.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {

    static let shared = UserManager()

    init() {}
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
    enum UserManagerError: Error {
        case invalidUserId
        case updateFailed(message: String)
        var localizedDescription: String {
            switch self {
            case .invalidUserId:
                return "Invalid user ID."
            case .updateFailed(let message):
                return "Failed to update user: \(message)"
            }
        }
    }
}
