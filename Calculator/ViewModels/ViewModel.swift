//
//  ViewModels.swift
//  Calculator
//
//  Created by Михаил Железовский on 15.02.2022.
//

import Foundation
import CoreData

class ViewModel {
    
    var resultText = Dynamic("")
    var historyText = Dynamic("")
    
    var curInput : Double {
        get {
            var value : Double? = Double(resultText.value)
            if value == nil {
                value = 0
                Calculator.firstNumber = 0
                Calculator.secondNumber = 0
                Calculator.secondNumberIsCurrentInput = false
                Calculator.isDouble =  false
            }
            return value!
        }
        set {
            // round to .0001
            let doubleStr = String(format: "%.4f", newValue)
            let val = Double(doubleStr)!
            
            if String(val).count > 15 || Calculator.maxDouble < val || Calculator.minDouble > val {
                resultText.value = "error"
            } else {
                let isInteger = floor(val) == val
                if isInteger {
                    resultText.value = "\(Int(val))"
                } else {
                    resultText.value = "\(val)"
                }
            }
            Calculator.secondNumberIsCurrentInput = false
        }
    }
    
    func firstSetCurInput(){
        curInput = UserDefaults.standard.double(forKey: "currentNumber")
    }
    
    func rememberCurInput(){
        UserDefaults.standard.set(curInput, forKey: "currentNumber")
    }
    
    
    func numberPressed(value: String){
        let number = value
        let curStr : String = Calculator.secondNumberIsCurrentInput ? resultText.value : ""
        
        if (curStr.count) < 15 {
            resultText.value = curStr + number
        }
        if !Calculator.secondNumberIsCurrentInput {
            Calculator.secondNumberIsCurrentInput = true
        }
    }
    
    func clearPressed() {
        Calculator.firstNumber = 0
        Calculator.secondNumber = 0
        Calculator.curSign = ""
        Calculator.secondNumberIsCurrentInput = false
        Calculator.isDouble =  false
        Calculator.bracketOn = false
        Calculator.bracketString = ""
        Calculator.beforeBracket = 0
        
        curInput = 0
        historyText.value = ""
        resultText.value = "0"
    }
    
    func doAMath() {
        if Calculator.secondNumberIsCurrentInput {
            Calculator.secondNumber = curInput
        }
        
        Calculator.isDouble = false
        
        switch Calculator.curSign {
        case "+" : performMathOperation{$0 + $1}
        case "-" : performMathOperation{$0 - $1}
        case "×" : performMathOperation{$0 * $1}
        case "÷" : performMathOperation{$0 / $1}
        case "xʸ" : performMathOperation{pow($0, $1)}
        default : break
        }
    }
    
    func performMathOperation(operation: (Double, Double) -> Double) {
        curInput = operation(Calculator.firstNumber, Calculator.secondNumber)
        Calculator.secondNumberIsCurrentInput = false
        
        setHistoryTwoOperands()
    }
    
    func clearTrigonometric(previousNumber: Double, curFunc: String) {
        numberPressed(value: String(curInput))
        Calculator.curSign = ""
        Calculator.firstNumber = curInput
        Calculator.secondNumberIsCurrentInput = false
        setHistoryOneOperand(previousNumber: previousNumber, curFunc: curFunc)
    }
    
    func oneFunction(curFunc: String) {
        
        let previousNumber = curInput
        
        switch curFunc {
        case "sin" : curInput = sin(curInput * Double.pi / 180)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "cos" : curInput = cos(curInput * Double.pi / 180)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "tan" : curInput = tan(curInput * Double.pi / 180)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "log₁₀" : curInput = log10(curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "ln" : curInput = log(curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "√" : curInput = sqrt(curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "∛" : curInput = sqrt(curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "x²" : curInput = pow(curInput, 2)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "x³" : curInput = pow(curInput, 3)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "e" : curInput = Constants.e
            numberPressed(value: String(curInput))
        case "∏" : curInput = Double.pi
            numberPressed(value: String(curInput))
        case "+/-" : curInput = -curInput
        case "10ˣ" : curInput = pow(10, curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "eˣ" : curInput = exp(curInput)
            clearTrigonometric(previousNumber: previousNumber, curFunc: curFunc)
        case "m+" : Calculator.mValue = curInput
        case "m-" : Calculator.mValue = -curInput
        case "mc" : Calculator.mValue = 0
            curInput = Calculator.mValue
            if !Calculator.secondNumberIsCurrentInput {
                Calculator.secondNumberIsCurrentInput = true
            }
        case "mr" : curInput = Calculator.mValue
            if !Calculator.secondNumberIsCurrentInput {
                Calculator.secondNumberIsCurrentInput = true
            }
        default : break
        }
    }
    
    func setHistoryOneOperand(previousNumber: Double, curFunc: String) {
        if resultText.value != "error" {
            let previousNumStr = String(format: "%.4f", previousNumber)
            let previousNum = Double(previousNumStr)!
            var previous = ""
            
            let previousIsInteger = floor(previousNum) == previousNum
            if previousIsInteger {
                previous = "\(Int(previousNum))"
            } else {
                previous = "\(previousNum)"
            }
            
            let firstSymbol = historyText.value == "" ? "" : "\n"
            let currentString = curFunc + " \(previous) = \(resultText.value)"
            if Calculator.bracketString != "" {
                Calculator.bracketString += currentString
            } else if currentString != Calculator.historyLastLine {
                historyText.value += firstSymbol + currentString
                Calculator.historyLastLine = currentString
            }
        }
    }
    
    func setHistoryTwoOperands() {
        if resultText.value != "error" {
            let firstNumStr = String(format: "%.4f", Calculator.firstNumber)
            let secondNumStr = String(format: "%.4f", Calculator.secondNumber)
            let firstNum = Double(firstNumStr)!
            let secondNum = Double(secondNumStr)!
            var first = ""
            var second = ""
            
            let fitstIsInteger = floor(firstNum) == firstNum
            if fitstIsInteger {
                first = "\(Int(firstNum))"
            } else {
                first = "\(firstNum)"
            }
            let secondIsInteger = floor(secondNum) == secondNum
            if secondIsInteger {
                second = "\(Int(secondNum))"
            } else {
                second = "\(secondNum)"
            }
            
            let firstSymbol = historyText.value == "" ? "" : "\n"
            let currentString = first + " \(Calculator.curSign) \(second) = \(resultText.value)"
            
            if Calculator.bracketString != "" && Calculator.bracketOn  {
                let lastChar = Calculator.bracketString.last!
                if lastChar == "(" {
                    Calculator.bracketString += first + " \(Calculator.curSign) \(second)"
                } else {
                    Calculator.bracketString += " \(Calculator.curSign) \(second)"
                }
            } else if Calculator.bracketString != "" && !Calculator.bracketOn {
                let lastChar = Calculator.bracketString.last!
                if lastChar == "(" {
                    Calculator.bracketString += first + " \(Calculator.curSign) \(second)) = \(resultText.value)"
                } else {
                    Calculator.bracketString += " \(Calculator.curSign) \(second)) = \(resultText.value)"
                }
                historyText.value += firstSymbol + Calculator.bracketString
                Calculator.historyLastLine = Calculator.bracketString
                Calculator.bracketString = ""
                Calculator.bracketOn = false
            } else if currentString != Calculator.historyLastLine {
                historyText.value += firstSymbol + Calculator.bracketString + currentString
                Calculator.historyLastLine = Calculator.bracketString + currentString
            }
        }
    }
    
    func bracketOffPressed(){
        if Calculator.bracketString != "" && Calculator.bracketOn {
            Calculator.bracketOn = false
            
            doAMath()
            
            if Calculator.signBracket != "" {
                Calculator.firstNumber = Calculator.beforeBracket
                Calculator.curSign = Calculator.signBracket
                Calculator.signBracket = ""
            } else {
                Calculator.secondNumberIsCurrentInput = false
                Calculator.firstNumber = curInput
                Calculator.secondNumber = 0
                Calculator.curSign = ""
            }
        }
    }
    
    func bracketOnPressed(){
        if !Calculator.bracketOn && Calculator.bracketString.isEmpty {
            Calculator.bracketOn = true
            Calculator.beforeBracket = curInput
            Calculator.signBracket = Calculator.curSign
            
            Calculator.bracketString = "("
            
            Calculator.firstNumber = 0
            Calculator.curSign = ""
        }
    }
    
    func setFacktorial() {
        let isInteger = floor(curInput) == curInput
        if isInteger {
            curInput = factorial(Int(curInput))
        } else {
            resultText.value = "error"
        }
    }
    
    func factorial(_ n: Int) -> Double {
        return (1...n).map(Double.init).reduce(1.0, *)
    }
    
    func dotPressed() {
        if Calculator.secondNumberIsCurrentInput && !Calculator.isDouble {
            resultText.value = resultText.value + "."
            Calculator.isDouble = true
        } else if !Calculator.secondNumberIsCurrentInput && !Calculator.isDouble {
            resultText.value = "0."
        }
    }
    
    func procentPressed() {
        if Calculator.firstNumber == 0 {
            curInput = curInput / 100
        } else {
            Calculator.secondNumber = Calculator.firstNumber * curInput / 100
        }
        Calculator.secondNumberIsCurrentInput = false
    }
    
    func signPressed(curSign: String) {
        Calculator.curSign = curSign
        Calculator.firstNumber = curInput
        Calculator.secondNumberIsCurrentInput = false
        Calculator.isDouble = false
    }
}

