//
//  LoadingView.swift
//  DHC
//
//  Created by Trio on 1.05.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Spacing.spacing_1) {
            ProgressView()
            Text("Loading...")
        }

    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
