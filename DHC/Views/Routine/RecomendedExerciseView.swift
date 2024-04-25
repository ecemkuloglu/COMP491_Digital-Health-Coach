//
//  RecomendedExerciseView.swift
//  DHC
//
//  Created by Lab on 26.04.2024.
//

import SwiftUI

struct RecomendedExerciseView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ExerciseViewModel

    var body: some View {
        List {
            Section(header: Text("Excercıes")) {
                ForEach(viewModel.filteredExercises, id: \.self) { exercise in
                    Text(exercise)
                }
            }
        }
        .onAppear {
            viewModel.filterExercises()
        }
    }
}
