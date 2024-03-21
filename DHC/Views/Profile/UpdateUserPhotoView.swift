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
            PHPickerView(viewModel: viewModel)
                .onAppear {
                    requestPhotoLibraryAccess()
                }
            Spacer()
        }
        .padding()
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Access to photo library authorized")
            case .denied, .restricted:
                print("Access to photo library denied or restricted")
            case .notDetermined:
                print("Access to photo library not determined")
            case .limited:
                print("Access to photo library limited")
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }
}


struct UpdateUserPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserPhotoView(viewModel: ProfileViewModel())
    }
}
