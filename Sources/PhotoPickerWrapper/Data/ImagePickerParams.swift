//
//  ImagePickerParams.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation
import PhotosUI
import UIKit

public struct ImagePickerParams {
    
    public var selectionLimit: Int
    public var filter: PHPickerFilter?
    public var allowsEditing: Bool
    public var sourceType: ImagePickerSourceType
    public var mediaType: ImagePickerMediaType
    public var tintColor: UIColor

    public init(selectionLimit: Int, filter: PHPickerFilter? = nil, allowsEditing: Bool, sourceType: ImagePickerSourceType, mediaType: ImagePickerMediaType, tintColor: UIColor = .systemBlue) {
        self.selectionLimit = selectionLimit
        self.filter = filter
        self.allowsEditing = allowsEditing
        self.sourceType = sourceType
        self.mediaType = mediaType
        self.tintColor = tintColor
    }
}
