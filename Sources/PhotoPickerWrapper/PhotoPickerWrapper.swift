//
//  PhotoPickerWrapper.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation
import PhotosUI
import SwiftUI

public typealias PhotoPickerCallback = ((AssetData) -> Void)
public typealias ErrorPickerCallback = (([Error]) -> Void)

public class PhotoPickerWrapper: NSObject {
    
    // MARK: - Parametets
    public var params: ImagePickerParams
    
    // MARK: - Callbacks
    public var didAssetSelected: PhotoPickerCallback?
    public var didHandlePickerErrors: ErrorPickerCallback?

    public init(params: ImagePickerParams, didAssetSelected: PhotoPickerCallback?, didHandlePickerErrors: ErrorPickerCallback? = nil) {
        self.params = params
        self.didAssetSelected = didAssetSelected
        self.didHandlePickerErrors = didHandlePickerErrors
    }
    
    /// Diplay picker
    /// - Parameter parentVC: Parent view controoler
    public func showPicker(on parentVC: UIViewController) {
        let picker = self.createPickerVC()
        parentVC.present(picker, animated: true, completion: nil)
    }
    
    /// Request permission from the user to access the photo gallery
    /// - Parameters:
    ///   - onAllow: Permission granted callback
    ///   - onDeny: Permission denied callback
    public static func tryGetPhotoPermission(onAllow: (() -> Void)?, onDeny: (() -> Void)?) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                status == .authorized ? onAllow?() : onDeny?()
            }
        }
    }
    
    /// Request permission from the user to access the camera
    /// - Parameters:
    ///   - onAllow: Permission granted callback
    ///   - onDeny: Permission denied callback
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
extension PhotoPickerWrapper {
    
    /// Create a picker with the earlier defined parametersr
    /// - Returns: Photo controller, UIImagePickerController or PHPickerViewController
    func createPickerVC() -> UIViewController {
        switch params.sourceType {
        case let .camera(mediaType):
            let picker = UIImagePickerController()
            picker.allowsEditing = params.allowsEditing
            picker.sourceType = .camera
            picker.mediaTypes = mediaType == .photo ? ["public.image"] : ["public.movie"]
            picker.cameraCaptureMode = mediaType
            picker.delegate = self

            return picker
        case let .photoLibrary(filter):
            let picker = PHPickerViewController(configuration: createPhotoPickerConfiguration(filter: filter))
            picker.navigationController?.navigationBar.tintColor = params.tintColor
            picker.delegate = self
            
            return picker
        }
    }
    
    /// Create configuration for PHPicker
    /// - Parameter filter: Picker filter
    /// - Returns: Configuration
    private func createPhotoPickerConfiguration(filter: PHPickerFilter?) -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = filter
        config.selectionLimit = params.selectionLimit
        
        return config
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerWrapper: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var selectedAssets = AssetData(images: [], videoUrls: [])
        var errors: [Error] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            dispatchGroup.enter()
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let error = error {
                        print("Failed load image: \(error.localizedDescription)")
                        errors += [error]
                    }
                    if let image = object as? UIImage {
                        selectedAssets.images += [image.normalizedImage()]
                    }
                    dispatchGroup.leave()
                }
            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
                    if let error = error {
                        print("Failed load video: \(error.localizedDescription)")
                        errors += [error]
                    }
                    if let videoURL = url {
                        selectedAssets.videoUrls += [videoURL]
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.didAssetSelected?(selectedAssets)
            if !errors.isEmpty {
                self?.didHandlePickerErrors?(errors)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoPickerWrapper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var selectedAssets = AssetData(images: [], videoUrls: [])
        
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image" {
                if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                    selectedAssets.images += [image.normalizedImage()]
                }
            } else if mediaType == "public.movie" {
                if let videoURL = info[.mediaURL] as? URL {
                    selectedAssets.videoUrls += [videoURL]
                }
            }
        }
        
        self.didAssetSelected?(selectedAssets)
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
