//
//  MotivationView.swift
//  DHC
//
//  Created by Lab on 28.03.2024.
//

import SwiftUI

struct MotivationView: View {
    @ObservedObject var viewModel = MotivationViewModel()
        
    var body: some View {
        VStack {
            Text("Time to Move")
                .padding()
        }
        .onAppear {
            viewModel.sendMotivationQuote()
        }
    }
}

