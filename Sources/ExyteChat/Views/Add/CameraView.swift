import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var didFinishPicking: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if let url = saveImageToTempDirectory(image: image) {
                    DispatchQueue.main.async { [weak self] in
                        self?.parent.didFinishPicking(url)
                    }
                }
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        private func saveImageToTempDirectory(image: UIImage) -> URL? {
            let fileManager = FileManager.default
            let tempDir = fileManager.temporaryDirectory
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = tempDir.appendingPathComponent(fileName)

            if let data = image.jpegData(compressionQuality: 1.0) {
                do {
                    try data.write(to: fileURL)
                    return fileURL
                } catch {
                    print("Ошибка при сохранении изображения: \(error)")
                    return nil
                }
            }

            return nil
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
