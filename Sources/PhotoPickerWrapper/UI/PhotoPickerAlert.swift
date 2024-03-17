//
//  PhotoPickerAlert.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import SwiftUI

public class PhotoPickerAlert {
    
    static func alertTitle(for type: ImagePickerSourceType) -> String {
        switch type {
        case .camera:
            return ImagePickerLocale.cameraUnavailableTitle.locale
        case .photoLibrary:
            return ImagePickerLocale.galleryUnavailableTitle.locale
        }
    }
    
    static func alertMessage(for type: ImagePickerSourceType) -> String {
        switch type {
        case .camera:
            return ImagePickerLocale.cameraUnavailableMessage.locale
        case .photoLibrary:
            return ImagePickerLocale.galleryUnavailableMessage.locale
        }
    }
}

public class PhotoPickerErrorAlert {
    
    public static func presentAlert(for type: ImagePickerSourceType, in viewController: UIViewController) {
        let alertController = UIAlertController(
            title: PhotoPickerAlert.alertTitle(for: type),
            message: PhotoPickerAlert.alertMessage(for: type),
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(
            title: ImagePickerLocale.openSettings.locale,
            style: .default,
            handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
        
        alertController.addAction(UIAlertAction(
            title: ImagePickerLocale.cancel.locale,
            style: .cancel,
            handler: nil
        ))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

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
                title: Text(PhotoPickerAlert.alertTitle(for: type)),
                message: Text(PhotoPickerAlert.alertMessage(for: type)),
                primaryButton: .default(Text(ImagePickerLocale.openSettings.locale), action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
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
