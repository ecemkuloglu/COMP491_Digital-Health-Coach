//
//  ExerciseModel.swift
//  DHC
//
//  Created by Trio on 14.04.2024.
//

import Foundation

struct ExerciseModel: Codable {
    let name: String
    let desc: String
    let photoUrl: String
    let exp_needed_asMonth: Int
    let focus_area: String
    let goal: String
    let loc_preference: String
    
}
