//
//  SearchListRow.swift
//  DHC
//
//  Created by Trio on 1.05.2024.
//

import SwiftUI

struct SearchListRow: View {
    
    private let exercise: ExerciseModel
    
    init(exercise: ExerciseModel) {
        self.exercise = exercise
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text("Goal: \(exercise.goal)")
                    .font(.subheadline)
                Text("Focus Area: \(exercise.focus_area)")
                    .font(.subheadline)
            }
    }
}

struct SearchListRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchListRow(exercise: ExerciseModel(name: "Test", desc: "Test", photo_url: "https://www.ottawapublichealth.ca/en/public-health-topics/resources/Images/sbe/sbe-8.jpg", exp_before: "Test", focus_area: "Test", goal: "Test", loc_preference: "Test"))
    }
}
