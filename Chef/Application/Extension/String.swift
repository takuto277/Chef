//
//  String.swift
//  Chef
//
//  Created by 小野拓人 on 2025/02/09.
//

import Foundation
import UIKit

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}
