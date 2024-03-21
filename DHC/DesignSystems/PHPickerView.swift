//
//  PHPickerView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ProfileViewModel
    
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else {
                print("PHPicker result is empty")
                picker.dismiss(animated: true)
                return
            }

            let provider = results[0].itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading image:", error.localizedDescription)
                            picker.dismiss(animated: true)
                            return
                        }

                        if let image = image as? UIImage {
                            self.parent.viewModel.selectedImage = image

                            Task {
                                do {
                                    try await self.parent.viewModel.saveProfileImage()
                                } catch {
                                    print("Error saving profile image:", error)
                                }
                            }
                            picker.dismiss(animated: true)
                        }
                    }
                }
            } else {
                print("Could not load image")
                picker.dismiss(animated: true)
            }
        }
    }
    
}



struct PHPickerView_Previews: PreviewProvider {
    static var previews: some View {
        return PHPickerView(viewModel: ProfileViewModel())
    }
}
