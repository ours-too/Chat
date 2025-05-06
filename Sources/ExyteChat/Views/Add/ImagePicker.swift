import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode

    var didFinishPicking: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker


        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            var imageURLs = [URL]()

            for result in results {
                let provider = result.itemProvider

                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) { // VTODO: Не приходит URL изображения отсюда
                    provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                        guard let url = url else {
                            print("URL не получен: \(error?.localizedDescription ?? "неизвестная ошибка")")
                            return
                        }
                        imageURLs.append(url)
                    }
                }
            }
            self.parent.didFinishPicking(imageURLs)
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // TODO: Ограничение выбора изображений
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
