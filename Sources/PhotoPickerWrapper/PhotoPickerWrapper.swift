//
//  PhotoPickerWrapper.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation
import PhotosUI
import SwiftUI

public class PhotoPickerWrapper: NSObject {
    
    public var params: ImagePickerParams
    
    public var onImagesPicked: (([UIImage]) -> Void)?
    public var onVideosPicked: (([URL]) -> Void)?
    
    public init(params: ImagePickerParams, onImagesPicked: (([UIImage]) -> Void)? = nil, onVideosPicked: (([URL]) -> Void)? = nil) {
        self.params = params
        self.onImagesPicked = onImagesPicked
        self.onVideosPicked = onVideosPicked
    }
    
    public func showPicker(on parentVC: UIViewController) {
        let picker = self.createPickerVC()
        parentVC.present(picker, animated: true, completion: nil)
    }
    
    private func createPhotoPickerConfiguration() -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = params.filter
        config.selectionLimit = params.selectionLimit
        return config
    }
    
    public static func tryGetPhotoPermission(onAllow: (() -> Void)?, onDeny: (() -> Void)?) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                status == .authorized ? onAllow?() : onDeny?()
            }
        }
    }
    
    public static func tryGetCameraPermission(onAllow: (() -> Void)?, onDeny: (() -> Void)?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                onAllow?()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? onAllow?() : onDeny?()
                }
            }
        default:
            onDeny?()
        }
    }
}

// MARK: - Module methods
private extension PhotoPickerWrapper {
    
    func createPickerVC() -> UIViewController {
        switch params.sourceType {
        case .camera:
            let picker = UIImagePickerController()
            picker.allowsEditing = params.allowsEditing
            picker.sourceType = .camera
            picker.delegate = self
            
            switch params.mediaType {
            case .photo:
                picker.cameraCaptureMode = .photo
            case .video:
                picker.cameraCaptureMode = .video
            }
            
            return picker
        case .photoLibrary:
            let picker = PHPickerViewController(configuration: createPhotoPickerConfiguration())
            picker.navigationController?.navigationBar.tintColor = params.tintColor
            picker.delegate = self
            
            return picker
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerWrapper: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var selectedImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                guard let url = url,
                      let filter = CIFilter(imageURL: url),
                      let ciImage = filter.outputImage
                else {
                    dispatchGroup.leave()
                    return
                }
                
                let image = UIImage(ciImage: ciImage)
                selectedImages.append(image.normalizedImage())
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.onImagesPicked?(selectedImages)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoPickerWrapper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image",
                let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                self.onImagesPicked?([image.normalizedImage()])
            } else if mediaType == "public.movie" {
                if let videoURL = info[.mediaURL] as? URL {
                    self.onVideosPicked?([videoURL])
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwiftUI wrapper
public struct ImagePicker: UIViewControllerRepresentable {
    
    public var picker: PhotoPickerWrapper
    
    public init(picker: PhotoPickerWrapper) {
        self.picker = picker
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        picker.createPickerVC()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
    }
}
