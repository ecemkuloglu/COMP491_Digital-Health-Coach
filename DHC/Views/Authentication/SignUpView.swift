//
//  SignUpView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            TextField("", text: $viewModel.username, prompt: Text("Username...")
                        .foregroundColor(Color.white))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
            
            TextField("", text: $viewModel.email, prompt: Text("Email...")
                        .foregroundColor(Color.white))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
            
            SecureField("", text: $viewModel.password, prompt: Text("Password...")
                            .foregroundColor(Color.white))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
            
            ButtonDS(buttonTitle: "Sign Up") {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        viewModel.errorString = ""
                        return
                    } catch {
                        viewModel.errorString = error.localizedDescription
                    }
                }
            }
            Text(viewModel.errorString)
                .foregroundStyle(Color.red)
            Spacer()
        }
        .padding(Spacing.spacing_3)
        .navigationTitle("Sign Up")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SignUpView(showSignInView: .constant(true))
        }
    }
}
