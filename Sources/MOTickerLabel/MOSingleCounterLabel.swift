//
//  MOSingleCounterLabel.swift
//  MOTickerLabel
//
//  Created by Mosaic Engineering on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit
import Foundation

public class MOSingleCounterLabel: UIView {
    lazy var runningAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0, animations: nil)
        animator.scrubsLinearly = false
        return animator
    }()
    
    public var textColor: UIColor = .label {
        didSet {
            numberWheel.arrangedSubviews.forEach {
                ($0 as? UILabel)?.textColor = textColor
            }
        }
    }
    
    public var font: UIFont = .boldSystemFont(ofSize: 14) {
        didSet {
            numberWheel.arrangedSubviews.compactMap { $0 as? UILabel }.forEach {
                $0.font = font
                $0.setFontSizeToFill()
                $0.sizeToFit()
            }
            
            scrollView.setNeedsLayout()
            scrollView.layoutIfNeeded()
            setNeedsLayout()
            layoutIfNeeded()
        
            if let val = value {
                scrollView.setContentOffset(offset(of: val), animated: true)
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
        
    lazy var numberLabels: [UILabel] = {
        return (0...9).map {
            let label = UILabel(frame: self.frame)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "\($0)"
            label.font = font
            label.textColor = textColor
            label.setFontSizeToFill()
            label.sizeToFit()
            return label
        }
    }()
    
    lazy var numberWheel: UIStackView = {
        let stackView = UIStackView(frame: self.frame)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        numberLabels.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.addArrangedSubview(UIView())
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
    
    init(frame: CGRect, value: Int, font: UIFont? = nil) {
        super.init(frame: frame)
        self.value = value
        
        if let customFont = font {
            self.font = customFont
        }
        
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
            runningAnimator.stopAnimation(true)
            scrollView.contentOffset = self.scrollView.contentOffset
        }
        
        runningAnimator.addAnimations {
            self.scrollView.setContentOffset(destinationOffset, animated: true)
        }
        runningAnimator.startAnimation()
    }
}
