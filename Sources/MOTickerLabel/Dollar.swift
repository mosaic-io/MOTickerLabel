//
//  Dollar.swift
//  Ticker Label
//
//  Created by Mike Choi on 2/29/20.
//  Copyright © 2020 Mosaic. All rights reserved.
//

import Foundation

public struct Dollar: Comparable, CustomStringConvertible {
    static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var amount: Float
    
    var numberOfDigits: Int {
        if amount < 1 { return 3 }
        else { return Int(floor(log10(amount))) + 1 + 2 }
    }
    
    public var description: String {
        Dollar.commaFormatter.string(from: NSNumber(value: Double(amount))) ?? "$---"
    }
    
    public init(float: Float) {
        amount = Float(round(100 * float) / 100)
    }
    
    public static func < (lhs: Dollar, rhs: Dollar) -> Bool {
        lhs.amount < rhs.amount
    }
    
    /**
     Algorithm is `(1234 // (10 ** 2)) % 10`
     
     - Returns: nth element of `amount`, where `0`th element is the least significant digit
     - Note: Returns `nil` if provided index is out of bounds
     */
    func digit(at i: Int) -> Int? {
        if amount == 0.00  { return 0 }
        if i >= numberOfDigits { return nil }
        
        let decimalsRemoved = Int(amount * 100)
        let divisionFactor = Int(pow(Double(10), Double(numberOfDigits - i - 1)))
        let movedToOne = decimalsRemoved / divisionFactor
        return movedToOne % 10
    }
}
