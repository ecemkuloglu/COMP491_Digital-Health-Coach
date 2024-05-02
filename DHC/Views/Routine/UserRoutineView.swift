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
        //ScrollView {
            VStack {
                Text("Your Routine").font(.title)
                ScrollView {
                //Text("Your Routine").font(.title)
                CalendarView(selectedDate: $selectedDate)
                                    Picker("Select Exercise", selection: $viewModel.selectedExerciseIndex) {
                                        ForEach(0..<viewModel.exercises.count, id: \.self) { index in
                                            Text(viewModel.exercises[index]).tag(index)
                                        }
                                    }
                                    //.pickerStyle(WheelPickerStyle())
                                    .pickerStyle(MenuPickerStyle())
                DurationPickerView(viewModel: viewModel)
                VStack {
                    Button("Save") {
                        viewModel.saveExercise()
                        viewModel.selectedDate = selectedDate
                        savedData.append("\(viewModel.exercises[viewModel.selectedExerciseIndex]) done for \(viewModel.minutesRange[viewModel.selectedMinutesIndex]) min \(viewModel.secondsRange[viewModel.selectedSecondsIndex]) sec")
                    }
                    .padding()
                    
                    NavigationLink(destination: ExerciseView(isPresented: $showExerciseView, savedData: $savedData, selectedDate: selectedDate, viewModel: viewModel), isActive: $showExerciseView) {
                        EmptyView()
                    }
                }
                VStack {
                    Button("Your done exercises") {
                        showExerciseView = true
                    }
                    .padding()
                    
                    NavigationLink(destination: ExerciseView(isPresented: $showExerciseView, savedData: $savedData, selectedDate: selectedDate, viewModel: viewModel), isActive: $showExerciseView) {
                        EmptyView()
                    }
                }
                VStack {
                    Button("Your recommended exercises") {
                        showRecomendedExerciseView = true
                    }
                    .padding()
                    
                    NavigationLink(destination: RecomendedExerciseView(isPresented: $showRecomendedExerciseView, viewModel: viewModel), isActive: $showRecomendedExerciseView) {
                        EmptyView()
                    }
                }
            }

        
        }
        
    }
}
struct DurationPickerView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack {
            HStack {
                Text("Duration (min):")
                
                Picker("", selection: $viewModel.selectedMinutesIndex) {
                    ForEach(0..<viewModel.minutesRange.count, id: \.self) { index in
                        Text("\(viewModel.minutesRange[index])").tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                Text("Duration (sec):")
                
                Picker("", selection: $viewModel.selectedSecondsIndex) {
                    ForEach(0..<viewModel.secondsRange.count, id: \.self) { index in
                        Text("\(viewModel.secondsRange[index])").tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
               
  
            }
            .padding()
        }
    }
}


struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            
            DatePicker(
              
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            //.frame(width: 280, height: 300)
            .frame(width: 320, height: 320)
        }
      
    }

}

