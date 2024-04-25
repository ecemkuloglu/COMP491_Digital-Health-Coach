import SwiftUI
import HealthKit

struct UserRoutineView: View {
    @State private var stepCount: Int = 0
    @State private var showExerciseView: Bool = false
    @State private var exercises: [ExerciseModel] = []
    
    private var currentUserId: String = "user_id" // !!!!!!
    
    var body: some View {
        NavigationView {
            List(exercises, id: \.name) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name)
                    Text(exercise.desc)
                }
            }
            .onAppear {
                loadExercises()
            }
            VStack {
                Spacer()
                CalendarView()
                Spacer()
                Text("Step Count: \(stepCount)")
                ButtonDS(buttonTitle: "Your exercises") {
                    showExerciseView.toggle()
                }
            }
           // .sheet(isPresented: $showExerciseView) {
             //  ExerciseView(showExerciseView: $showExerciseView)
             //}
            .padding(Spacing.spacing_1)
            .navigationTitle("Routine Page")
        }
    }
    
     private func loadExercises() {
     Task {
     do {
     let userPreferences = try await UserManager.shared.fetchUserPreferences(userId: currentUserId)
     exercises = try await ExerciseManager.shared.getExercisesMatchingPreferences(preferences: userPreferences)
     } catch {
     print("Error fetching exercises: \(error)")
            }
        }
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
