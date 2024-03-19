//
//  UpdateUserPhotoView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import PhotosUI

struct UpdateUserPhotoView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            PHPickerView(selectedImage: $viewModel.selectedImage)
                .onDisappear {
                    if let image = viewModel.selectedImage {
                        viewModel.image = Image(uiImage: image)
                    }
                }
            Spacer()
        }
        .padding()
    }
}


struct UpdateUserPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserPhotoView(viewModel: ProfileViewModel())
    }
}
