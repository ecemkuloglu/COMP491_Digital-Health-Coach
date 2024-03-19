//
//  TitleText.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI

struct TitleText: View {

    private let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .lineLimit(2)
            .font(.title)
            .padding(.vertical, Spacing.spacing_2)
            .padding(.horizontal, Spacing.spacing_2)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText(text: "Test")
    }
}
