//  ProfileView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var showInfoView = false  // State to control navigation to InfoView

    var body: some View {
            VStack(spacing: .zero) {
                HStack {
                    Spacer()
                    infoView
                }
                usernameView
                profilePhoto
                    .onTapGesture {
                        viewModel.isEditingPhoto = true
                    }
                NavigationLink(destination: PreferencePageView(preferences: preferences)) {
                    Text("Change your preferences")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
                buttonView
                Spacer()
            }
            .task {
                try? await viewModel.loadCurrentUser()
                if let user = viewModel.user, let path = viewModel.user?.photoUrl {
                    let data = try? await StorageManager.shared.getData(userId: user.userId, path: path)
                    viewModel.imageData = data
                }
            }
            .sheet(isPresented: $viewModel.isEditingPhoto) {
                UpdateUserPhotoView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.isEditingUsername) {
                UpdateUsernameView(viewModel: viewModel)
            }
            .navigationTitle("Profile")
            .background(NavigationLink(destination: InfoView(), isActive: $showInfoView) { EmptyView() })
        
    }
    
    private var infoView: some View {
        Image(systemName: "info.circle")
            .foregroundColor(.blue)
            .onTapGesture {
                showInfoView = true  // Activate navigation to InfoView
            }
            .popover(isPresented: $viewModel.isInfo) {
                Text("Tap on the picture or username to edit them")
                    .font(.headline)
                    .padding()
            }
            .padding(Spacing.spacing_3)
            .font(.headline)
    }
    
    private var usernameView: some View {
        TitleText(text: viewModel.user?.username ?? "No username found")
            .onTapGesture {
                viewModel.isEditingUsername = true
            }
    }
    
    private var buttonView: some View {
        ButtonDS(buttonTitle: "Sign out") {
            Task {
                do {
                    try viewModel.signOut()
                    showSignInView = true
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private var profilePhoto: some View {
        let placeholderImage = Image(systemName: "photo.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 400, height: 400)
            .padding(Spacing.spacing_5)
        
        _ = viewModel.image
        
        if let photoUrl = viewModel.user?.photoUrl, !photoUrl.isEmpty {
            if let data = viewModel.imageData, let image = UIImage(data: data) {
                return AnyView(
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .padding(Spacing.spacing_5)
                )
            }
        } else {
            return AnyView(
                placeholderImage
            )
        }
        return AnyView(
            placeholderImage
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(true))
    }
}



struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Dear user, \nTime to Move! prioritizes being a health coach to everyone who wants to live a healthy life. For us to be able to help you efficiently, we would like you to enter your preferences to your profile so that we can recommend exercises to you that you would want. You can find your preferences settings on your profile. You can find the recommended exercises on your routine page. \nTo be able to save your progression you can save exercises which you have done and their duration. You can find the completed exercises on your routine page. \n You can choose exercises that you want to do from the routine page and add them to your saved exercises, which is also on the routine page.\n Time to Move! allows you to measure your balance, and to see your progress on your balance you can do the “Balance Test”. ")
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Spacer()
        }
    }
}

