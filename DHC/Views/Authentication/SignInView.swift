//
//  SignInView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject private var viewModel = SignViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        login
    }
    
    private var login: some View {
        VStack {
            TextField("", text: $viewModel.email, prompt: Text("Email...").foregroundColor(Color.white))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("", text: $viewModel.password, prompt: Text("Password...").foregroundColor(Color.white))
                .padding(Spacing.spacing_2)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .autocapitalization(.none)
            
            ButtonDS(buttonTitle: "Sign In") {
                Task {
                    do {
                        try await viewModel.signIn()
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
        .navigationTitle("Sign In")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView(showSignInView: .constant(true))
        }
    }
}
