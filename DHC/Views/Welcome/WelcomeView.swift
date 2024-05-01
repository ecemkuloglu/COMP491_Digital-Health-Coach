//
//  WelcomeView.swift
//  DHC
//
//  Created by Lab on 1.05.2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showBalanceView = false
    @ObservedObject var viewModel = BalanceViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
                .padding()

            VStack {
                //buraya günlük bilgiler
                Color.blue
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding(.horizontal)
                //buraya da motivasyon sözleri
                Color.blue
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            //buraya ödüller eklensin
            VStack {
                Color.blue
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)

            Button("You can test your balance from there") {
                showBalanceView = true
            }
            .padding()
            .buttonStyle(.borderedProminent)
            NavigationLink(destination: BalanceView(viewModel: viewModel, isPresented: $showBalanceView), isActive: $showBalanceView) {
                EmptyView()
            }
        }
    }
}
