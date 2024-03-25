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
            Text("Welcome to your routine page!")
                .position(x: 130, y:40)
                .padding()
            //taken from developer.apple.com
            CalendarView()
                .frame(width: 320, height: 300)
                .position(x: 180, y:-80)
            Text("Step Count: \(stepCount)")
            
            Button("Look your exercises") {
                showExerciseView.toggle()
                        }
                        .padding()
                        .sheet(isPresented: $showExerciseView) {
                            ExerciseView(showExerciseView: $showExerciseView)
                        }
            
        }.padding()
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
