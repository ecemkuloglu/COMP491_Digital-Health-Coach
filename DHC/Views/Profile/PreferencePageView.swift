//
//  PreferencePageView.swift
//  DHC
//
//  Created by Lab on 4.04.2024.
//

import SwiftUI

struct PreferencePageView: View {
    let preferences: [Preference]  // This should be provided with actual preference data

    var body: some View {
        NavigationView {
            List(preferences, id: \.title) { preference in
                NavigationLink(destination: PreferenceSelectionView(preference: preference)) {
                    Text(preference.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Preferences")
        }
    }
}
