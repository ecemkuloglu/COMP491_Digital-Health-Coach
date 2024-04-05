//
//  UserRoutineView.swift
//  DHC
//
//  Created by Lab on 21.03.2024.
//

import SwiftUI
import HealthKit

struct UserRoutineView: View {
    @State private var stepCount: Int = 0
    @State private var showExerciseView: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            CalendarView()
            Spacer()
            Text("Step Count: \(stepCount)")
            ButtonDS(buttonTitle: "Your exercises") {
                showExerciseView.toggle()
            }
        }
        .sheet(isPresented: $showExerciseView) {
            ExerciseView(showExerciseView: $showExerciseView)
        }
        .padding(Spacing.spacing_1)
        .navigationTitle("Routine Page")
    }
}

struct CalendarView: View {
    @State private var date = Date()
    
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $date,
            displayedComponents: [.date]
        )
            .datePickerStyle(.graphical)
    }
}

struct UserRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        UserRoutineView()
    }
}
