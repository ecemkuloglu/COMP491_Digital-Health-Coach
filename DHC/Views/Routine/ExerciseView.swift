//
//  ExerciseView.swift
//  DHC
//
//  Created by Lab on 21.03.2024.
//

import SwiftUI

struct ExerciseView: View {
    @Binding var isPresented: Bool
    @Binding var savedData: [String]
    let selectedDate: Date
    @ObservedObject var viewModel: ExerciseViewModel

    var body: some View {
        List {
            Section(header: Text("Adım Sayısı")) {
                Text("\(viewModel.stepCount) adım")
            }
            Section(header: Text("Egzersizler")) {
                ForEach(viewModel.dailyExercises, id: \.self) { exercise in
                    Text(exercise)
                }
            }
        }
        .onAppear {
            viewModel.selectedDate = selectedDate
            viewModel.fetchExercisesForSelectedDate()
        }
    }
}
