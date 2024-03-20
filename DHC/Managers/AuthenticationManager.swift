//
//  AuthenticationManager.swift
//  DHC
//
//  Created by Trio on 12.03.2024.
//

import Foundation
import FirebaseAuth

class AuthenticationManager {

    static let shared = AuthenticationManager()

    private init() { }

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }

    @discardableResult
    func createUser(email: String, password: String,
                    username: String,
                    photoURL: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = authDataResult.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try? await changeRequest.commitChanges()
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw error
        }
    }

    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw error
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func getUserName() -> String {
        return Auth.auth().currentUser?.email ?? "Not Found"
    }

}
