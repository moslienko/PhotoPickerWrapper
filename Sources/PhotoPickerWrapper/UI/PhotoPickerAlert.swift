//
//  PhotoPickerAlert.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import SwiftUI

public protocol PhotoPickerErrorAlert: AnyObject {
    static func presentAlert(for type: ImagePickerSourceType, in viewController: UIViewController)
    static func alertTitle(for type: ImagePickerSourceType) -> String
    static func alertMessage(for type: ImagePickerSourceType) -> String
    static func openSettings()
}

// MARK: - PhotoPickerErrorAlert
extension PhotoPickerWrapper: PhotoPickerErrorAlert {
    
    /// Display an alert if the user has refused to give permissions
    /// - Parameters:
    ///   - type: Picker type
    ///   - viewController: Parent view controller
    public static func presentAlert(for type: ImagePickerSourceType, in viewController: UIViewController) {
        let alertController = UIAlertController(
            title: PhotoPickerWrapper.alertTitle(for: type),
            message: PhotoPickerWrapper.alertMessage(for: type),
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(
            title: ImagePickerLocale.openSettings.locale,
            style: .default,
            handler: { _ in
                PhotoPickerWrapper.openSettings()
            }))
        
        alertController.addAction(UIAlertAction(
            title: ImagePickerLocale.cancel.locale,
            style: .cancel,
            handler: nil
        ))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    public static func alertTitle(for type: ImagePickerSourceType) -> String {
        switch type {
        case .camera:
            return ImagePickerLocale.cameraUnavailableTitle.locale
        case .photoLibrary:
            return ImagePickerLocale.galleryUnavailableTitle.locale
        }
    }
    
    public static func alertMessage(for type: ImagePickerSourceType) -> String {
        switch type {
        case .camera:
            return ImagePickerLocale.cameraUnavailableMessage.locale
        case .photoLibrary:
            return ImagePickerLocale.galleryUnavailableMessage.locale
        }
    }
    
    public static func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - SwiftUI
public struct PhotoPickerAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let type: ImagePickerSourceType
    
    public init(isPresented: Binding<Bool>, type: ImagePickerSourceType) {
        self._isPresented = isPresented
        self.type = type
    }
    
    public func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(
                title: Text(PhotoPickerWrapper.alertTitle(for: type)),
                message: Text(PhotoPickerWrapper.alertMessage(for: type)),
                primaryButton: .default(Text(ImagePickerLocale.openSettings.locale), action: {
                    PhotoPickerWrapper.openSettings()
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

public extension View {
    func photoPickerErrorAlert(isPresented: Binding<Bool>, type: ImagePickerSourceType) -> some View {
        self.modifier(PhotoPickerAlertModifier(isPresented: isPresented, type: type))
    }
}
