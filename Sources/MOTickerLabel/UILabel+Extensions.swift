//
//  UILabel+Extensions.swift
//  MOTickerLabel
//
//  Created by Mike Choi on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit

extension UILabel {
    func setFontSizeToFill() {
        let frameSize  = self.bounds.size
        guard frameSize.height>0 && frameSize.width>0 && self.text != nil else {return}

        var fontPoints = self.font.pointSize
        var fontSize   = self.text!.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontPoints)])
        var increment  = CGFloat(0)

        if fontSize.width > frameSize.width || fontSize.height > frameSize.height {
            increment = -1
        } else {
            increment = 1
        }

        while true {
            fontSize = self.text!.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontPoints+increment)])
            if increment < 0 {
                if fontSize.width < frameSize.width && fontSize.height < frameSize.height {
                    fontPoints += increment
                    break
                }
            } else {
                if fontSize.width > frameSize.width || fontSize.height > frameSize.height {
                    break
                }
            }
            fontPoints += increment
        }

        self.font = self.font.withSize(fontPoints)
    }
}
