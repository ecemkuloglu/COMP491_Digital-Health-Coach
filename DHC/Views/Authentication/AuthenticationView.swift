//
//  AuthenticationView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            NavigationButtonDS(buttonTitle: "Sign In", destination: SignInView(showSignInView: $showSignInView))
            NavigationButtonDS(buttonTitle: "Sign Up", destination: SignUpView(showSignInView: $showSignInView))
            
        }
        .padding(Spacing.spacing_5)
        .navigationTitle("Welcome")
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthenticationView(showSignInView: .constant(true))
        }
    }
}
