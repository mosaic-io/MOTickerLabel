//
//  UIImageView+Extensions.swift
//  MOTickerLabel
//
//  Created by Mosaic Engineering on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!.withRenderingMode(.alwaysTemplate)
    }
}

