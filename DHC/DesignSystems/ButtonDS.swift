//
//  ButtonDS.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI

struct ButtonDS: View {
    
    private let buttonTitle: String
    private let action: () -> Void
    
    init(
        buttonTitle: String,
        action: @escaping () -> Void
    ) {
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        Button(
            action: action
        ) {
            Text(buttonTitle)
                .foregroundColor(.blue)
                .padding(.horizontal, Spacing.spacing_5)
                .padding(.vertical, Spacing.spacing_1)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.radius_4)
                        .stroke(.blue, lineWidth: 2)
                }
        }
        .padding(.vertical, Spacing.spacing_2)
    }
}

struct ButtonDS_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDS(buttonTitle: "test") { }
    }
}
