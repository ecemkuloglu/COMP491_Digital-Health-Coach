//
//  Goal.swift
//  DHC
//
//  Created by Lab on 4.04.2024.
//

import Foundation

struct Preference {
    let title: String
    let options: [String]
}

let preferences: [Preference] = [
    Preference(title: "Goal", options: ["Lose weight", "Get stronger", "Keep my form", "Increasing stamina", "Stress relief", "Increasing balance"]),
    Preference(title: "Age", options: ["18-25", "25-38", "38-50", "50-65", "65+"]),
    Preference(title: "Focus Area", options: ["Back", "shoulder", "abs", "chest", "arm","hip","leg"]),
    Preference(title: "Duration", options: ["15", "30", "45", "60", "90"]),
    Preference(title: "Fav sport", options: ["cycle", "running", "boxing", "yoga", "swimming"]),
    Preference(title: "Experince before", options: ["starter", "less than 1 year", "1-2", "2+"]),
    Preference(title: "Location", options: ["Gym", "Home", "Outdoor"])
]
