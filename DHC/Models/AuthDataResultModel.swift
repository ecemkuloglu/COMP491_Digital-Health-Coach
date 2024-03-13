//
//  AuthDataResultModel.swift
//  DHC
//
//  Created by Trio on 12.03.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {

    let uid: String
    let email: String?
    let photoURL: String?
    let displayName: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.displayName = user.displayName
    }
}
