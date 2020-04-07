//
//  MOTickerLabel.swift
//  MOTickerLabel
//
//  Created by Mosaic Engineering on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import UIKit

public class MOTickerLabel: UIView {
    
    lazy var runningAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0, animations: nil)
        animator.scrubsLinearly = false
        return animator
    }()
    
    lazy var arrayModificationAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0, animations: nil)
        animator.scrubsLinearly = false
        return animator
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: self.frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = -2
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var approximateFrame: CGRect = {
        CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
    }()
    
    public var textColor: UIColor = .label {
        didSet {
            stackView.arrangedSubviews.forEach {
                if let label = $0 as? MOSingleCounterLabel {
                    label.textColor = textColor
                } else {
                    ($0 as? UILabel)?.textColor = textColor
                }
            }
        }
    }
    
    public var font: UIFont = .boldSystemFont(ofSize: 14) {
        didSet {
            stackView.arrangedSubviews.forEach {
                if let label = $0 as? MOSingleCounterLabel {
                    label.font = font
                } else if let staticLabel = $0 as? UILabel {
                    staticLabel.font = font
                }
            }
        }
    }
    
    public var value: Dollar {
        didSet {
            animateDigitInsertion(from: oldValue, to: value)
            animate(from: oldValue, to: value)
        }
    }
    
    public init(frame: CGRect, value: Dollar) {
        self.value = value
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.value = Dollar(float: 0.0)
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.pin(to: self)
        setupInitialLabels()
    }
    
    func animate(from old: Dollar, to new: Dollar) {
        if runningAnimator.isRunning {
            runningAnimator.stopAnimation(false)
            runningAnimator.finishAnimation(at: .end)
        }
        
        runningAnimator.addAnimations {
            (0..<new.numberOfDigits).forEach { i in
                let label = self.label(at: i)
                label.value = new.digit(at: i)
            }
        }
        runningAnimator.startAnimation()
    }
    
    func animateDigitInsertion(from old: Dollar, to new: Dollar) {
        let diff = new.numberOfDigits - old.numberOfDigits
        
        switch diff {
        case let x where x < 0:
            var cnt = abs(x)
            while (cnt != 0 || stackView.arrangedSubviews[1] as? UILabel != nil) {
                let view = stackView.arrangedSubviews[1]
                view.removeFromSuperview()
                if view as? UILabel == nil {
                    cnt -= 1
                }
            }
        case let x where x > 0:
            (0..<x).compactMap { new.digit(at: $0) }
                .reversed()
                .map { (value: Int) -> MOSingleCounterLabel in
                    let label = MOSingleCounterLabel(frame: self.approximateFrame, value: value, font: self.font)
                    label.textColor = textColor
                    return label
                }
                .forEach { label in
                    self.stackView.insertArrangedSubview(label, at: 1)
                }
        default:
            break
        }
        
        stride(from: stackView.arrangedSubviews.count - 4, through: 0, by: -4).dropFirst().forEach { i in
            let view = stackView.arrangedSubviews[i]
            if view as? UILabel == nil {
                stackView.insertArrangedSubview(staticLabel(with: ","), at: i + 1)
            }
        }
        
        stackView.layoutIfNeeded()
    }
    
    func label(at idx: Int) -> MOSingleCounterLabel {
        stackView.arrangedSubviews.compactMap { $0 as? MOSingleCounterLabel }[idx]
    }
    
    func setupInitialLabels() {
        let numberLabels = (0..<value.numberOfDigits).compactMap {
            value.digit(at: $0)
        }.map { (value: Int) -> (MOSingleCounterLabel) in
            let label = MOSingleCounterLabel(frame: self.approximateFrame, value: value, font: self.font)
            label.font = self.font
            label.textColor = textColor
            return label
        }
        
        numberLabels.enumerated().forEach { (offset, label) in
            if offset % 3 == 1 && offset > 3 {
                stackView.addArrangedSubview(staticLabel(with: ","))
            }
            stackView.addArrangedSubview(label)
        }
        
        insertNotations()
        stackView.addArrangedSubview(UIView())
    }
    
    func insertNotations() {
        let dollarSign = staticLabel(with: "$")
        let period = staticLabel(with: ".")
        stackView.insertArrangedSubview(dollarSign, at: 0)
        stackView.insertArrangedSubview(period, at: stackView.arrangedSubviews.count - 2)
    }
    
    func staticLabel(with string: String) -> UILabel {
        let label = UILabel(frame: approximateFrame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = string
        label.font = font
        label.textAlignment = .center
        label.setFontSizeToFill()
        label.sizeToFit()
        label.textColor = textColor
        return label
    }
}
