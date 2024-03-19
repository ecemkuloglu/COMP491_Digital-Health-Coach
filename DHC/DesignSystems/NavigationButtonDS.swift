//
//  NavigationButtonDS.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import Combine
import Foundation

struct NavigationButtonDS<Content: View>: View {

    private let buttonTitle: String
    private let destination: Content

    init(buttonTitle: String, destination: Content) {
        self.buttonTitle = buttonTitle
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(buttonTitle)
                .foregroundColor(.blue)
                .padding(.horizontal, Spacing.spacing_5)
                .padding(.vertical, Spacing.spacing_1)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.radius_4)
                        .stroke(.blue, lineWidth: 2)
                }
        }
    }
}
struct NavigationButtonDS_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
               NavigationButtonDS(buttonTitle: "Test", destination: Text("test"))
           }
    }
}
