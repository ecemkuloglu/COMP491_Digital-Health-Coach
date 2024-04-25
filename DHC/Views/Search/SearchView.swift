

//
//  SearchView.swift
//  DHC
//
//  Created by Aylin Melek on 21.03.2024.
//

import SwiftUI

/*struct SearchView: View {
 var body: some View {
 VStack {
 HStack {
 Spacer()
 Button(action: {
 // Handle search button action here
 // You can implement your search logic
 }) {
 Image(systemName: "magnifyingglass")
 .font(.title)
 .foregroundColor(.blue)
 //.padding()
 }
 }
 Text("EXERCISES")
 .font(.subheadline)
 .padding()
 
 ScrollView {
 LazyVStack {
 ForEach(1..<11) { index in
 ExerciseBox(index: index)
 .padding(.vertical, 5)
 }
 }
 }
 
 Spacer()
 
 /*Button(action: {
  // Handle search button action here
  // You can implement your search logic
  }) {
  Text("Search")
  .font(.headline)
  .foregroundColor(.white)
  .padding()
  .background(Color.blue)
  .cornerRadius(10)
  }*/
 //.padding()
 
 
 }
 }
 }
 
 struct ExerciseBox: View {
 let index: Int
 
 var body: some View {
 RoundedRectangle(cornerRadius: 10)
 .fill(Color.gray.opacity(0.2))
 .frame(height: 100)
 .overlay(
 Text("Exercise #\(index)")
 .font(.headline)
 .foregroundColor(.black)
 )
 .padding(.horizontal)
 }
 }
 
 
 struct SearchView_Previews: PreviewProvider {
 static var previews: some View {
 SearchView()
 }
 }
 
 
 // SearchView.swift
 
 */



struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var body: some View {
        
        List(viewModel.exercises, id: \.name) { exercise in
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.desc)
                    .font(.subheadline)
            }
        }
        .onAppear {
            
            viewModel.loadExercises()
            print(viewModel.exercises.first?.name ?? "empty loaded exercises")
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
