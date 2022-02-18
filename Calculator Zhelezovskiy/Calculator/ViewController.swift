//
//  ViewController.swift
//  Calculator
//
//  Created by Михаил Железовский on 09.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainButtons: [UIButton]!
    @IBOutlet weak var resultLabel: UILabel!
    var used = false
    var isDouble = false
    var firstNum : Double = 0
    var secondNum : Double = 0
    var curSign = ""
    let maxDouble : Double = Double(Int.max)
    let minDouble : Double = Double(Int.min)
    
    var beforeBracket : Double = 0
    var signBracket = ""
    
    var mr : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curInput = UserDefaults.standard.double(forKey: "currentNumber")
        
        for button in mainButtons {
            button.layer.cornerRadius = 8
        }
    }
    
    override func viewDidLayoutSubviews() {
        UserDefaults.standard.set(curInput, forKey: "currentNumber")
    }
    
    var curInput : Double {
        get {
            var value : Double? = Double(resultLabel.text!)
            if value == nil {
                value = 0
                firstNum = 0
                secondNum = 0
                used = false
                isDouble =  false
            }
            return value!
        }
        set {
            // round to .0001
            let doubleStr = String(format: "%.4f", newValue)
            let val = Double(doubleStr)!

            if String(val).count > 15 || maxDouble < val || minDouble > val {
                resultLabel.text = "error"
            } else {
                let isInteger = floor(val) == val
                if isInteger {
                    resultLabel.text = "\(Int(val))"
                } else {
                    resultLabel.text = "\(val)"
                }
            }
            used = false
        }
    }
    
    @IBAction func mrPressed(_ sender: UIButton) {
        curInput = mr
        used = true
    }
    
    @IBAction func mrcPressed(_ sender: UIButton) {
        mr = 0
        curInput = mr
        used = true
    }
    
    @IBAction func mMinusPressed(_ sender: UIButton) {
        mr = -curInput
    }
    
    @IBAction func mPlusPressed(_ sender: UIButton) {
        mr = curInput
    }
    
    @IBAction func ePressed(_ sender: UIButton) {
        curInput = Constants.e
    }
    
    @IBAction func piPressed(_ sender: UIButton) {
        curInput = Double.pi
    }
    
    @IBAction func signPressed(_ sender: UIButton) {
        curSign = sender.currentTitle!
        firstNum = curInput
        used = false
        isDouble = false
    }
    
    @IBAction func procentPressed(_ sender: UIButton) {
        sender.pulsate()
        if firstNum == 0 {
            curInput = curInput / 100
        } else {
            secondNum = firstNum * curInput / 100
        }
        used = false
    }
    
    @IBAction func oneFunction(_ sender: UIButton) {
        let curFunc = sender.currentTitle!

        switch curFunc {
        case "sin" : curInput = sin(curInput * Double.pi / 180)
        case "cos" : curInput = cos(curInput * Double.pi / 180)
        case "tan" : curInput = tan(curInput * Double.pi / 180)
        case "log₁₀" : curInput = log10(curInput)
        case "ln" : curInput = log(curInput)
        case "√" : curInput = sqrt(curInput)
        case "∛" : curInput = sqrt(curInput)
        case "x²" : curInput = pow(curInput, 2)
        case "x³" : curInput = pow(curInput, 3)
        case "e" : curInput = Constants.e
        case "∏" : curInput = Double.pi
        case "+/-" : curInput = -curInput
            sender.pulsate()
        case "10ˣ" : curInput = pow(10, curInput)
        case "eˣ" : curInput = exp(curInput)
        default : break
        }
    }
    
    @IBAction func dotPressed(_ sender: UIButton) {
        if used && !isDouble {
            resultLabel.text = resultLabel.text! + "."
            isDouble = true
        } else if !used && !isDouble {
            resultLabel.text = "0."
        }
    }
    
    @IBAction func factorialPressed(_ sender: UIButton) {
        let isInteger = floor(curInput) == curInput
        if isInteger {
            curInput = factorial(Int(curInput))
        } else {
            resultLabel.text = "error"
        }
    }
    
    func factorial(_ n: Int) -> Double {
      return (1...n).map(Double.init).reduce(1.0, *)
    }
    
    func performMathOperation(operation: (Double, Double) -> Double) {
        let result = operation(firstNum, secondNum)
        curInput = result
        
        used = false
    }
    
    @IBAction func euqalPressed(_ sender: UIButton) {
        doAMath()
        sender.pulsate()
    }
    
    func doAMath() {
        if used {
            secondNum = curInput
        }

        isDouble = false

        switch curSign {
        case "+" : performMathOperation{$0 + $1}
        case "-" : performMathOperation{$0 - $1}
        case "×" : performMathOperation{$0 * $1}
        case "÷" : performMathOperation{$0 / $1}
        case "xʸ" : performMathOperation{pow($0, $1)}
        default : break
        }
    }
    
    @IBAction func bracketOnPressed(_ sender: UIButton) {
        beforeBracket = curInput
        signBracket = curSign
        
        firstNum = 0
        curSign = ""
    }
    
    @IBAction func bracketOffPressed(_ sender: UIButton) {
        
        doAMath()
        
        if signBracket != "" {
            firstNum = beforeBracket
            curSign = signBracket
            used = true
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        sender.pulsate()
        firstNum = 0
        secondNum = 0
        curSign = ""
        curInput = 0
        resultLabel.text = "0"
        used = false
        isDouble =  false
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        let curStr : String = used == true ? resultLabel.text! : ""
        
        if (curStr.count) < 15 {
            resultLabel.text = curStr + number
        }
        if !used {
            used = true
        }
    }
}

struct Constants {
    static let pi = 3.1416
    static let e = 2.7182
    let phi = 1.618
}
