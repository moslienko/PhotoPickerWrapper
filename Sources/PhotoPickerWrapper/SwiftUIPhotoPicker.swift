//
//  SwiftUIPhotoPicker.swift
//
//
//  Created by Pavel Moslienko on 19.03.2024.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI wrapper
public struct SwiftUIPhotoPicker: UIViewControllerRepresentable {
    
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
        let parent: SwiftUIPhotoPicker
        
        init(_ parent: SwiftUIPhotoPicker) {
            self.parent = parent
        }
    }
}
