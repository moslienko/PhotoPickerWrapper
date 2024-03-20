//
//  ImagePickerLocale.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation

enum ImagePickerLocale: String {
    
    static private let key = "ImagePickerLocale."
    
    case cameraUnavailableTitle = "camera_unavailable_title"
    case galleryUnavailableTitle = "gallery_unavailable_title"
    case galleryUnavailableMessage = "gallery_unavailable_msg"
    case cameraUnavailableMessage = "camera_unavailable_msg"
    case openSettings = "open_settings"
    case cancel = "cancel"

    var locale: String {
        String.locale(for: ImagePickerLocale.key + self.rawValue)
    }
}
