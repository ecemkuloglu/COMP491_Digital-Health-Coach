//
//  SignViewModel.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import Foundation
import PhotosUI
import SwiftUI

class SignViewModel: ObservableObject {

    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorString = ""
    @Published var photoURL: String = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw(SignInError.emptyEmailOrPassword)
        }

        let authDataResult = try await AuthenticationManager.shared.createUser(
            email: email,
            password: password,
            username: username,
            photoURL: photoURL)

        try await UserManager.shared.createUser(auth: authDataResult)
    }
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw(SignInError.emptyEmailOrPassword)
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }

    enum SignInError: Error {
        case emptyEmailOrPassword
        case otherError(message: String)

        var localizedDescription: String {
            switch self {
            case .emptyEmailOrPassword:
                return "No email or password found."
            case .otherError(let message):
                return message
            }
        }
    }
}
