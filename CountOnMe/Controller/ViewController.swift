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
