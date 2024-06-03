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
        ScrollView {
            VStack {
                Text("Awards").font(.title)
                if viewModel.awards.isEmpty {
                    Text("There are no awards earned. To earn awards keep doing exercises")
                        .onAppear {
                            Task {
                                await viewModel.updateAwards()
                            }
                        }
                } else {
                    ForEach(viewModel.awards, id: \.title) { award in
                        VStack(alignment: .leading) {
                            Text(award.title).font(.headline)
                            Text(award.description).font(.subheadline).foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    }
                }
            }
            .padding()
        }
    }
}
