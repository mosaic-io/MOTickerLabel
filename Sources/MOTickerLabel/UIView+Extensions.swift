//
//  UIView+Extensions.swift
//  MOTickerLabel
//
//  Created by Mosaic Engineering on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit

extension UIView {
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
