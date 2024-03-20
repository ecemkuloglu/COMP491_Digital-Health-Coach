//
//  ProfileViewModel.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import Foundation
import SwiftUI
import PhotosUI
import Photos

class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: UserModel?
    @Published var isEditingPhoto = false
    @Published var isEditingUsername: Bool = false
    @Published var isInfo = false
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    @Published var image: Image?
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func loadCurrentUser() async throws {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            
            DispatchQueue.main.async {
                self.user = user
            }
        } catch {
            print("Error loading current user: \(error)")
            throw error
        }
    }
    
    func updateUsername(newUsername: String) async throws {
        do {
            guard let userId = user?.userId else {
                throw ProfileViewModelError.invalidUserId
            }
            
            try await UserManager.shared.updateUsername(userId: userId, newUsername: newUsername)
            
            try await loadCurrentUser()
        } catch {
            throw ProfileViewModelError.updateFailed(message: error.localizedDescription)
        }
    }
    
    func updateProfilePhoto(newPhotoURL: String) async throws {
        do {
            guard let userId = user?.userId else {
                throw ProfileViewModelError.invalidUserId
            }
            try await UserManager.shared.updateUserPhoto(userId: userId, newPhotoURL: newPhotoURL)
            
            try await loadCurrentUser()
        } catch {
            throw ProfileViewModelError.updateFailed(message: error.localizedDescription)
        }
    }
    
    func saveProfileImage() async throws {
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        guard let userId = user?.userId else {
            throw ProfileViewModelError.invalidUserId
        }
        
        do {
            let (_, name) = try await StorageManager.shared.saveImage(data: imageData, userId: userId)
            try await UserManager.shared.updateUserPhoto(userId: userId, newPhotoURL: name)
            try await loadCurrentUser()
        } catch {
            throw ProfileViewModelError.updateFailed(message: error.localizedDescription)
        }
    }
    
    enum ProfileViewModelError: Error {
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
