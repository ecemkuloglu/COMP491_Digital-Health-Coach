//
//  ExerciseView.swift
//  DHC
//
//  Created by Lab on 21.03.2024.
//

import SwiftUI

import SwiftUI

struct ExerciseView: View {
    @Binding var isPresented: Bool
    @Binding var savedData: [String]
    let selectedDate: Date
    @ObservedObject var viewModel: ExerciseViewModel

    var body: some View {
        List(viewModel.dailyExercises, id: \.self) { exercise in
            Text(exercise)
        }
        .onAppear {
            viewModel.selectedDate = selectedDate
            viewModel.fetchExercisesForSelectedDate()
        }
    }
}
