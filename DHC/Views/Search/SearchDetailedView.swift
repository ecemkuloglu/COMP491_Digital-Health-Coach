//
//  SearchDetailedView.swift
//  DHC
//
//  Created by Trio on 1.05.2024.
//

import SwiftUI

struct SearchDetailedView: View {
    
    private let exercise: ExerciseModel
    
    init(exercise: ExerciseModel) {
        self.exercise = exercise
    }
    
    var body: some View {
        VStack(spacing: Spacing.spacing_2) {
            TitleText(text: exercise.name)
            imageView
            detailsView
        }
    }
    
    var imageView: some View {
        AsyncImage(url: URL(string: exercise.photo_url )) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .border(Color.primary)
            
        } placeholder: {
            Rectangle()
                .frame(width: 175, height: 175)
                .foregroundColor(.clear)
        }
    }
    
    var detailsView: some View {
        VStack(alignment: .leading, spacing: Spacing.spacing_1) {
            Text("Description:")
                .fontWeight(.bold)
            Text(exercise.desc)
            
            Text("Experience Before:")
                .fontWeight(.bold)
            Text(exercise.exp_before)
            
            Text("Focus Area:")
                .fontWeight(.bold)
            Text(exercise.focus_area)
            
            Text("Goal:")
                .fontWeight(.bold)
            Text(exercise.goal)
            
            Text("Location Preference:")
                .fontWeight(.bold)
            Text(exercise.loc_preference)
        }
        .padding(.horizontal, Spacing.spacing_1)

    }
    
    struct SearchDetailedView_Previews: PreviewProvider {
        static var previews: some View {
            SearchDetailedView(exercise: ExerciseModel(name: "Test", desc: "Test", photo_url: "https://www.ottawapublichealth.ca/en/public-health-topics/resources/Images/sbe/sbe-8.jpg", exp_before: "Test", focus_area: "Test", goal: "Test", loc_preference: "Test"))
        }
    }
}
