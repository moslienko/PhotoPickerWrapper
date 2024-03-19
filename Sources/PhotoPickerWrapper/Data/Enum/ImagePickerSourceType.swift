//
//  ImagePickerSourceType.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation
import PhotosUI

public enum ImagePickerSourceType {
    case camera(type: ImagePickerMediaType)
    case photoLibrary(filter: PHPickerFilter?)
}
