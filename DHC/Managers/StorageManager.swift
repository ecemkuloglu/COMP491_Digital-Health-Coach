//
//  StorageManager.swift
//  DHC
//
//  Created by Trio on 13.03.2024.
//

import Foundation
import FirebaseStorage

class StorageManager {

    static let shared = StorageManager()
    private init() { }
    private let storage = Storage.storage().reference()
    private var imagesReference: StorageReference {
        storage.child("images")
    }

    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }

    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"

        let path = "\(UUID().uuidString).jpeg"
        do {
            let returnedMetaData = try await userReference(userId: userId)
                .child(path)
                .putDataAsync(data, metadata: meta)

            guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
                throw URLError(.badServerResponse)
            }

            return (returnedPath, returnedName)
        } catch {
            print("Error putting data to Firebase Storage: \(error)")
            throw error
        }
    }

    func getData(userId: String, path: String) async throws -> Data {
        try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
    }

}