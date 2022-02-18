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
                Calcul.firstNumber = 0
                Calcul.secondNumber = 0
                Calcul.secondNumIsCurrentInput = false
                Calcul.isDouble =  false
            }
            return value!
        }
        set {
            // round to .0001
            let doubleStr = String(format: "%.4f", newValue)
            let val = Double(doubleStr)!
            
            if String(val).count > 15 || Calcul.maxDouble < val || Calcul.minDouble > val {
                resultText.value = "error"
            } else {
                let isInteger = floor(val) == val
                if isInteger {
                    resultText.value = "\(Int(val))"
                } else {
                    resultText.value = "\(val)"
                }
            }
            Calcul.secondNumIsCurrentInput = false
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
        let curStr : String = Calcul.secondNumIsCurrentInput ? resultText.value : ""
        
        if (curStr.count) < 15 {
            resultText.value = curStr + number
        }
        if !Calcul.secondNumIsCurrentInput {
            Calcul.secondNumIsCurrentInput = true
        }
    }
    
    func clearPressed() {
        Calcul.firstNumber = 0
        Calcul.secondNumber = 0
        Calcul.curSign = ""
        Calcul.secondNumIsCurrentInput = false
        Calcul.isDouble =  false
        Calcul.bracketOn = false
        Calcul.bracketString = ""
        Calcul.beforeBracket = 0
        
        curInput = 0
        historyText.value = ""
        resultText.value = "0"
    }
    
    func doAMath() {
        if Calcul.secondNumIsCurrentInput {
            Calcul.secondNumber = curInput
        }
        
        Calcul.isDouble = false
        
        switch Calcul.curSign {
        case "+" : performMathOperation{$0 + $1}
        case "-" : performMathOperation{$0 - $1}
        case "×" : performMathOperation{$0 * $1}
        case "÷" : performMathOperation{$0 / $1}
        case "xʸ" : performMathOperation{pow($0, $1)}
        default : break
        }
    }
    
    func performMathOperation(operation: (Double, Double) -> Double) {
        curInput = operation(Calcul.firstNumber, Calcul.secondNumber)
        Calcul.secondNumIsCurrentInput = false
        
        setHistoryTwoOperands()
    }
    
    func clearTrigonometric(previousNumber: Double, curFunc: String) {
        numberPressed(value: String(curInput))
        Calcul.curSign = ""
        Calcul.firstNumber = curInput
        Calcul.secondNumIsCurrentInput = false
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
        case "m+" : Calcul.mValue = curInput
        case "m-" : Calcul.mValue = -curInput
        case "mc" : Calcul.mValue = 0
            curInput = Calcul.mValue
            if !Calcul.secondNumIsCurrentInput {
                Calcul.secondNumIsCurrentInput = true
            }
        case "mr" : curInput = Calcul.mValue
            if !Calcul.secondNumIsCurrentInput {
                Calcul.secondNumIsCurrentInput = true
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
            if Calcul.bracketString != "" {
                Calcul.bracketString += currentString
            } else if currentString != Calcul.historyLastLine {
                historyText.value += firstSymbol + currentString
                Calcul.historyLastLine = currentString
            }
        }
    }
    
    func setHistoryTwoOperands() {
        if resultText.value != "error" {
            let firstNumStr = String(format: "%.4f", Calcul.firstNumber)
            let secondNumStr = String(format: "%.4f", Calcul.secondNumber)
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
            let currentString = first + " \(Calcul.curSign) \(second) = \(resultText.value)"
            
            if Calcul.bracketString != "" && Calcul.bracketOn  {
                let lastChar = Calcul.bracketString.last!
                if lastChar == "(" {
                    Calcul.bracketString += first + " \(Calcul.curSign) \(second)"
                } else {
                    Calcul.bracketString += " \(Calcul.curSign) \(second)"
                }
            } else if Calcul.bracketString != "" && !Calcul.bracketOn {
                let lastChar = Calcul.bracketString.last!
                if lastChar == "(" {
                    Calcul.bracketString += first + " \(Calcul.curSign) \(second)) = \(resultText.value)"
                } else {
                    Calcul.bracketString += " \(Calcul.curSign) \(second)) = \(resultText.value)"
                }
                historyText.value += firstSymbol + Calcul.bracketString
                Calcul.historyLastLine = Calcul.bracketString
                Calcul.bracketString = ""
                Calcul.bracketOn = false
            } else if currentString != Calcul.historyLastLine {
                historyText.value += firstSymbol + Calcul.bracketString + currentString
                Calcul.historyLastLine = Calcul.bracketString + currentString
            }
        }
    }
    
    func bracketOffPressed(){
        if Calcul.bracketString != "" && Calcul.bracketOn {
            Calcul.bracketOn = false
            
            doAMath()
            
            if Calcul.signBracket != "" {
                Calcul.firstNumber = Calcul.beforeBracket
                Calcul.curSign = Calcul.signBracket
                Calcul.signBracket = ""
            } else {
                Calcul.secondNumIsCurrentInput = false
                Calcul.firstNumber = curInput
                Calcul.secondNumber = 0
                Calcul.curSign = ""
            }
        }
    }
    
    func bracketOnPressed(){
        if !Calcul.bracketOn && Calcul.bracketString.isEmpty {
            Calcul.bracketOn = true
            Calcul.beforeBracket = curInput
            Calcul.signBracket = Calcul.curSign
            
            Calcul.bracketString = "("
            
            Calcul.firstNumber = 0
            Calcul.curSign = ""
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
        if Calcul.secondNumIsCurrentInput && !Calcul.isDouble {
            resultText.value = resultText.value + "."
            Calcul.isDouble = true
        } else if !Calcul.secondNumIsCurrentInput && !Calcul.isDouble {
            resultText.value = "0."
        }
    }
    
    func procentPressed() {
        if Calcul.firstNumber == 0 {
            curInput = curInput / 100
        } else {
            Calcul.secondNumber = Calcul.firstNumber * curInput / 100
        }
        Calcul.secondNumIsCurrentInput = false
    }
    
    func signPressed(curSign: String) {
        Calcul.curSign = curSign
        Calcul.firstNumber = curInput
        Calcul.secondNumIsCurrentInput = false
        Calcul.isDouble = false
    }
}

