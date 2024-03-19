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
    public var sourceType: ImagePickerSourceType
    public var allowsEditing: Bool
    public var tintColor: UIColor

    public init(selectionLimit: Int, sourceType: ImagePickerSourceType, allowsEditing: Bool = false, tintColor: UIColor = .systemBlue) {
        self.selectionLimit = selectionLimit
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
        self.tintColor = tintColor
    }
}
