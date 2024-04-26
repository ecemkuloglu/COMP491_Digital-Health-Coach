//
//  UserRoutineView.swift
//  DHC
//
//  Created by Lab on 21.03.2024.
//

import SwiftUI

struct UserRoutineView: View {
    @State private var showExerciseView = false
    @State private var showRecomendedExerciseView = false
    @ObservedObject var viewModel = ExerciseViewModel()
    @State private var savedData: [String] = []
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CalendarView(selectedDate: $selectedDate)
                    NavigationLink(destination: ExerciseView(isPresented: $showExerciseView, savedData: $savedData, selectedDate: selectedDate, viewModel: viewModel), isActive: $showExerciseView) {
                        EmptyView()
                    }
                    NavigationLink(destination: RecomendedExerciseView(isPresented: $showRecomendedExerciseView, viewModel: viewModel), isActive: $showRecomendedExerciseView) {
                        EmptyView()
                    }
                    Picker("Select Exercise", selection: $viewModel.selectedExerciseIndex) {
                        ForEach(0..<viewModel.exercises.count, id: \.self) { index in
                            Text(viewModel.exercises[index]).tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    DurationPickerView(viewModel: viewModel)
                    
                    Button("Save") {
                        viewModel.saveExercise()
                        viewModel.selectedDate = selectedDate
                        savedData.append("\(viewModel.exercises[viewModel.selectedExerciseIndex]) done for \(viewModel.minutesRange[viewModel.selectedMinutesIndex]) min \(viewModel.secondsRange[viewModel.selectedSecondsIndex]) sec")
                    }.padding()
                    Button("Your done exercises") {
                        showExerciseView = true
                    }
                    Button("Your recomended exercises") {
                        showRecomendedExerciseView = true
                    }
                }
                .padding()
                .navigationTitle("Routine Page")
            }
        }
    }
}

struct DurationPickerView: View {
    @ObservedObject var viewModel: ExerciseViewModel

    var body: some View {
        HStack {
            Text("Duration (min):")
            Picker("", selection: $viewModel.selectedMinutesIndex) {
                ForEach(0..<viewModel.minutesRange.count, id: \.self) { index in
                    Text("\(viewModel.minutesRange[index])").tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)

            Text("Duration (sec):")
            Picker("", selection: $viewModel.selectedSecondsIndex) {
                ForEach(0..<viewModel.secondsRange.count, id: \.self) { index in
                    Text("\(viewModel.secondsRange[index])").tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(GraphicalDatePickerStyle())
    }
}
