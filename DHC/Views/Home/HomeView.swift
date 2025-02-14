//  ContentView.swift
//  DHC
//
//  Created by Aylin Melek on 5.03.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 3
    @State private var showSignInView: Bool = false
    @StateObject var balanceViewModel = BalanceViewModel()
    
    var body: some View {
        ZStack {
            bottomView
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationView {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
    
    private var bottomView: some View {
        TabView(selection: $selection) {
            UserRoutineView()
                .tabItem {
                    Image(systemName: "shuffle")
                }
                .tag(1)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(2)
            WelcomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(3)
            ChatbotView()
                .tabItem {
                    Image(systemName: "circle.badge.questionmark.fill")
                }
                .tag(4)
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                }
                .tag(5)
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
