//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
    private let calculator = Calculator()
  
    @IBOutlet weak var textView: UITextView!
    
 
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculator.delegate = self
        textView.text = "0"
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
      guard let numberButton = sender.title(for: .normal) else { return }
        calculator.tappedNumberButton(number: numberButton)
    }

    @IBAction func tappedOperandButton(_ sender: UIButton) {
      guard let operandButton = sender.title(for: .normal) else {  return }
       calculator.tappedOperandButton(operand: operandButton)
    }
  
    @IBAction func tappedEqualButton(_ sender: UIButton) {
      calculator.tappedEqualButton()
    }
  
    @IBAction func resetButton(_ sender: UIButton) {
      calculator.reset()
    }
}

  // MARK: - Extension
  extension ViewController: DisplayDelegate {
      func updateDisplay(text: String) {
          textView.text = text
      }
      func presentAlert() {
          let alertVC = UIAlertController(title: "Erreur", message:
              "Veuillez entrer une expression correcte !", preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          return self.present(alertVC, animated: true, completion: nil)
      }
  }



/*
import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  private let calculator = Calculator()
  
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
      guard let numberButton = sender.title(for: .normal) else { return }
 
      if expressionHaveResult {
        textView.text = ""
      }
  
      textView.text.append(numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" + ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" - ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textView.text.append(" = \(operationsToReduce.first!)")
    }

}
 */
