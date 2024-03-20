//
//  UIImage+Ext.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation
import UIKit

public extension UIImage {
    
    func normalizedImage() -> UIImage {
        guard self.imageOrientation == .up else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        self.draw(in: CGRect(origin: .zero, size: self.size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
