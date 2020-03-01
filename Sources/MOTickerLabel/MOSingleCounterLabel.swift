//
//  MOSingleCounterLabel.swift
//  MOTickerLabel
//
//  Created by Mosaic Engineering on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit
import Foundation

final class MOSingleCounterLabel: UIView {
    lazy var runningAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: nil)
        animator.scrubsLinearly = false
        return animator
    }()
    
    public var textColor: UIColor = .label {
        didSet {
            numberWheel.arrangedSubviews.forEach {
                $0.tintColor = textColor
            }
        }
    }
    
    public var value: Int? {
        didSet {
            guard let newValue = value else {
                return
            }
            
            if let oldValue = oldValue, oldValue != newValue {
                animateChange(old: oldValue, new: newValue)
            }
        }
    }
    
    lazy var singleLabelHeight: CGFloat = {
        numberLabels[0].frame.height
    }()
        
    lazy var numberLabels: [UIImageView] = {
        return (0...9).map {
            let label = UILabel(frame: self.frame)
            label.textAlignment = .center
            label.text = "\($0)"
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.setFontSizeToFill()
            label.sizeToFit()
            let image = UIImage.imageWithLabel(label: label)
            let imageView = UIImageView(image: image)
            imageView.tintColor = textColor
            return imageView
        }
    }()
    
    lazy var numberWheel: UIStackView = {
        let stackView = UIStackView(frame: self.frame)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        numberLabels.forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(numberWheel)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0.0)
        numberWheel.pin(to: scrollView)
        numberWheel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        return scrollView
    }()
    
    var font: UIFont?
    
    init(frame: CGRect, value: Int) {
        super.init(frame: frame)
        self.value = value
        
        addSubview(scrollView)
        scrollView.pin(to: self)
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        scrollView.setContentOffset(offset(of: value), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func offset(of number: Int) -> CGPoint {
        let label = numberLabels[number]
        return CGPoint(x: 0, y: label.frame.minY)
    }
    
    func animateChange(old: Int, new: Int) {
        let destinationOffset = offset(of: new)
        
        if runningAnimator.isRunning {
            runningAnimator.pauseAnimation()
            scrollView.contentOffset = self.scrollView.contentOffset
        }
        
        runningAnimator.addAnimations {
            self.scrollView.setContentOffset(destinationOffset, animated: true)
        }
        runningAnimator.startAnimation()
    }
}
