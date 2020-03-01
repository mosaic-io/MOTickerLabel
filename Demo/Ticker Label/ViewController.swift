//
//  ViewController.swift
//  Ticker Label
//
//  Created by Mike Choi on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit
import Combine
import MOTickerLabel

final class ViewController: UIViewController {
    
    let slider = UISlider()
    let label = MOTickerLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50), value: Dollar(float: 12.03))
    
    @Published var value: Float?
    var sliderStream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        slider.minimumValue = 9
        slider.maximumValue = 999
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(slider)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slider.widthAnchor.constraint(equalToConstant: 350),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    
        sliderStream = $value
            .compactMap { $0 }
            .map { Dollar(float: $0) }
            .removeDuplicates()
            .debounce(for: 0.005, scheduler: RunLoop.main)
            .assign(to: \.value, on: self.label)
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        value = sender.value
    }
}
