//
//  AwardView.swift
//  DHC
//
//  Created by Lab on 26.04.2024.
//

import Foundation
import SwiftUI

struct AwardView: View {
    @ObservedObject var viewModel: AwardViewModel

    var body: some View {
        VStack {
            Text("Awards").font(.title)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) { // Adjust minimum width and spacing as needed
                    ForEach(viewModel.awards, id: \.name) { award in
                        AwardItemView(award: award, badge: viewModel.badges.first(where: { $0.id == award.badgeId }))
                    }
                }
            }
            .padding(.horizontal) // Add horizontal padding to the grid

        }
        .onAppear {
            // Fetch awards and badges when the view appears
            viewModel.fetchAwardsAndBadges()
        }
    }
}

struct AwardItemView: View {
    let award: Award
    let badge: Badge?
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            if let badgeData = badge?.data,
               let badgeImage = UIImage(data: badgeData) {
                Image(uiImage: badgeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            // Sadece tıklanan rozet için genişleme durumunu değiştir
                            isExpanded.toggle()
                        }
                    }
            }
            
            if isExpanded {
                VStack {
                    Text(award.name)
                        .font(.headline)
                    
                    Text(award.description)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10) // Corner radius for aesthetic a
        
    }
}
