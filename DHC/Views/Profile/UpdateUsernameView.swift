//
//  UpdateUsernameView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import PhotosUI

struct UpdateUsernameView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var newUsername = ""
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            
            Spacer()
            TitleText(text: "Enter New Username")
                .padding(Spacing.spacing_1)
            
            TextField("", text: $newUsername, prompt: Text("New Username..."))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
                .padding(Spacing.spacing_1)
                .foregroundColor(Color.white)
            
            ButtonDS(buttonTitle: "Save") {
                Task {
                    do {
                        try await viewModel.updateUsername(newUsername: newUsername)
                        viewModel.isEditingUsername = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}


struct UpdateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUsernameView(viewModel: ProfileViewModel())
    }
}
