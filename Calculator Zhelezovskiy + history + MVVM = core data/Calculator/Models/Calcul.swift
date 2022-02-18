//
//  Calcul.swift
//  Calculator
//
//  Created by Михаил Железовский on 15.02.2022.
//

import Foundation

struct Calcul {
    static var firstNumber: Double = 0
    static var secondNumber: Double = 0
    static var secondNumIsCurrentInput = false
    
    static var isDouble = false
    static var curSign = ""
    static let maxDouble : Double = Double(Int.max)
    static let minDouble : Double = Double(Int.min)
    
    static var bracketOn = false
    static var beforeBracket : Double = 0
    static var signBracket = ""
    
    static var mValue : Double = 0
    
    static var historyLastLine = ""
    static var bracketString = ""
}
