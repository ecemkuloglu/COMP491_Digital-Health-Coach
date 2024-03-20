//
//  PHPickerView.swift
//  DHC
//
//  Created by Trio on 19.03.2024.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

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
                picker.dismiss(animated: true)
                return
            }

            let provider = results[0].itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.parent.selectedImage = image
                        }
                    }
                }
            } else {
                print("Could not load image")
            }
            picker.dismiss(animated: true)
        }
    }
}



struct PHPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedImage = Binding<UIImage?>(
            get: { return nil },
            set: { _ in }
        )
        return PHPickerView(selectedImage: selectedImage)
    }
}
