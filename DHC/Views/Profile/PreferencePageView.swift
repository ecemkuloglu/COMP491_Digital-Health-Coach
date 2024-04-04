//
//  PreferencePageView.swift
//  DHC
//
//  Created by Lab on 4.04.2024.
//

import SwiftUI
import Firebase

struct PreferencePageView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(preferences, id: \.title) { preference in
                    NavigationLink(destination: PreferenceSelectionView(preference: preference)) {
                        Text(preference.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("Preferences")
        }
    }
}

struct PreferenceSelectionView: View {
    let preference: Preference
    @State private var selectedOptionIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(preference.title)
                .font(.title)
                .padding()

            ForEach(0..<preference.options.count) { index in
                Button(action: {
                    selectedOptionIndex = index
                    savePreference()
                }) {
                    Text(preference.options[index])
                        .font(.headline)
                        .foregroundColor(selectedOptionIndex == index ? .white : .blue)
                        .padding()
                        .background(selectedOptionIndex == index ? Color.blue : Color.clear)
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle(preference.title)
    }

    func savePreference() {
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }

        let userRef = db.collection("users").document(currentUser.uid)
        let field = "\(preference.title.lowercased().replacingOccurrences(of: " ", with: "_"))_preference"
        let option = preference.options[selectedOptionIndex]

        userRef.setData([field: option], merge: true) { error in
            if let error = error {
                print("Error saving preference for \(preference.title): \(error.localizedDescription)")
            } else {
                print("Preference saved successfully for \(preference.title): \(option)")
            }
        }
    }
}
