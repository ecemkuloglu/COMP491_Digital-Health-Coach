//
//  ExerciseView.swift
//  DHC
//
//  Created by Lab on 21.03.2024.
//

import SwiftUI

struct ExerciseView: View {
    @Binding var showExerciseView: Bool
    
    var body: some View {
        Text("Exercise list for you")
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
      ExerciseView(showExerciseView: .constant(true))
    }
}
