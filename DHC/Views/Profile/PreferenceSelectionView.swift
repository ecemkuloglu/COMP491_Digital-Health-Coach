//
//  PreferenceSelectionView.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import SwiftUI

struct PreferenceSelectionView: View {
    var preference: Preference
    @ObservedObject var viewModel = PreferenceViewModel()
    @State private var selectedOptionIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select your preference for \(preference.title):")
                .font(.headline)
                .padding()

            ForEach(preference.options.indices, id: \.self) { index in
                Button(action: {
                    selectedOptionIndex = index
                    viewModel.savePreference(preferenceTitle: preference.title, option: preference.options[index])
                }) {
                    HStack {
                        if selectedOptionIndex == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                        Text(preference.options[index])
                    }
                }
                .padding(.vertical, 4)
            }
            
          Spacer()

            if let userPreference = viewModel.userPreference {
                Text("Your selection: \(userPreference)")
                    .font(.headline)
                    .padding(.top, 20)
            }
        }
        .padding()
        .navigationBarTitle(Text(preference.title))
        .onAppear {
            viewModel.fetchUserPreference(preferenceTitle: preference.title)
        }
    }
}
