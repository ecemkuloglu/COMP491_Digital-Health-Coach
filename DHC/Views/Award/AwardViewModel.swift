//
//  AwardViewModel.swift
//  DHC
//
//  Created by Lab on 26.04.2024.
//

import Foundation
import SwiftUI
import Firebase

class AwardViewModel: ObservableObject {
    @Published var awards: [Award] = []
    @Published var badges: [Badge] = [] // Array to hold badge data

    private var storageManager = StorageManager.shared

    func fetchAwardsAndBadges() {
        // Fetch awards from wherever you get them
        awards = [
            Award(name: "Welcome", badgeId: "welcome_badge", description: "You earn this when you sign up for the app for the first time!"),
            Award(name: "1 Week Award", badgeId: "1_week_badge", description: "You earn this when you exercise regularly for one week!")
            // Add more awards as needed
        ]

        // Fetch badge data for each award
        for award in awards {
            fetchBadgeData(badgeId: award.badgeId)
        }
    }

    private func fetchBadgeData(badgeId: String) {
        Task {
            do {
                let badgeData = try await storageManager.getBadgeData(badgeId: badgeId, path: "\(badgeId).png")
                DispatchQueue.main.async {
                    self.badges.append(Badge(id: badgeId, data: badgeData))
                }
            } catch {
                print("Error fetching badge data: \(error)")
            }
        }
    }
}

struct Award {
    let name: String
    let badgeId: String
    let description: String
}

struct Badge {
    let id: String
    let data: Data
}
