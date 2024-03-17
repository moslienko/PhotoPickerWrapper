//
//  String+Ext.swift
//
//
//  Created by Pavel Moslienko on 17.03.2024.
//

import Foundation

public extension String {
    
    static func locale(for key: String) -> String {
        NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
}
