//
//  ViewController.swift
//  Calculator
//
//  Created by Михаил Железовский on 09.02.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var viewModel = ViewModel()
    var container: NSPersistentContainer!
    
    @IBOutlet private var mainButtons: [UIButton]!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var historyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedValues = self.retrieveValues()
        if savedValues["historyText"] != nil {
            historyText.text = savedValues["historyText"]
            viewModel.historyText.value = savedValues["historyText"] ?? ""
        }
    
        bindViewModel()
        viewModel.firstSetCurInput()
        
        for button in mainButtons {
            button.layer.cornerRadius = 8
        }
    }
    
    private func bindViewModel(){
        viewModel.resultText.bind({ (resultText) in
            DispatchQueue.main.async {
                self.resultLabel.text = resultText
            }
        })
        viewModel.historyText.bind({ (historyText) in
            DispatchQueue.main.async {
                self.historyText.text = historyText
            }
        })
    }
    
    
    override func viewDidLayoutSubviews() {
        viewModel.rememberCurInput()
        self.save(value: historyText.text ?? "")
    }
    
    @IBAction private func signPressed(_ sender: UIButton) {
        viewModel.signPressed(curSign: sender.currentTitle ?? "")
    }
    
    @IBAction private func procentPressed(_ sender: UIButton) {
        sender.pulsate()
        viewModel.procentPressed()
    }
    
    @IBAction private func oneFunction(_ sender: UIButton) {
        let curFunc = sender.currentTitle ?? ""
        if curFunc == "+/-" {
            sender.pulsate()
        }
        viewModel.oneFunction(curFunc: curFunc)
    }
    
    @IBAction private func dotPressed(_ sender: UIButton) {
        viewModel.dotPressed()
    }
    
    @IBAction private func factorialPressed(_ sender: UIButton) {
        viewModel.setFacktorial()
    }
    
    @IBAction private func euqalPressed(_ sender: UIButton) {
        sender.pulsate()
        viewModel.doAMath()
    }
    
    @IBAction private func bracketOnPressed(_ sender: UIButton) {
        viewModel.bracketOnPressed()
    }
    
    @IBAction private func bracketOffPressed(_ sender: UIButton) {
        viewModel.bracketOffPressed()
    }
    
    @IBAction private func clearPressed(_ sender: UIButton) {
        sender.pulsate()
        viewModel.clearPressed()
    }
    
    @IBAction private func numberPressed(_ sender: UIButton) {
        viewModel.numberPressed(value: sender.currentTitle ?? "")
    }
}

extension ViewController {
    
    func save(value: String){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "CalculatorEntity", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(value, forKey: "historyText")
            
            do {
                try context.save()
            } catch {
                print("Saving error")
            }
        }
    }
    
    func retrieveValues() -> [String:String] {
        
        var dictValues = [String:String]()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<CalculatorEntity>(entityName: "CalculatorEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let historyText = result.historyText {
                        dictValues["historyText"] = historyText
                    }
                }
            } catch {
                print("Could not retrieve")
            }
        }
        return dictValues
    }
}
