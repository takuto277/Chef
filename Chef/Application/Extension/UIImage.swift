//
//  UIImage.swift
//  Chef
//
//  Created by 小野拓人 on 2024/11/29.
//

import Foundation
import UIKit

extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 1.0)
    }

    static func from(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
