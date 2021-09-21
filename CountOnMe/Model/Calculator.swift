//
//  Calculator.swift
//  CountOnMe
//
//  Created by José DEGUIGNE on 21/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import UIKit

// Using Delegate Protocol to send display data to the View Controller:
protocol DisplayDelegate: AnyObject {
    func updateDisplay(text: String)
    func presentAlert()
}

  class Calculator: UIViewController {

  // MARK: - Properties
  
  weak var delegate: DisplayDelegate?
  // Array storing elements of the math expression:
  var elements: [String] = []
  // Display sent to View Controller by the delegate:
  var display: String {
      return elements.joined()
  }
  
  // This variable checks all possible errors in the expression preventing from producing a result

  var lastElementIsOperand: Bool {
      guard let lastElement = elements.last else { return false }
      return lastElement == "+" || lastElement == "-"
  }
  var lastElementIsNumber: Bool {
      guard let lastElement = display.last else { return false }
      return lastElement.isNumber == true
  }
  var expressionHasOperand: Bool {
      return elements.contains("+") || elements.contains("-")
  }
    
    // Error check computed variables
  var expressionIsCorrect: Bool {
      return elements.count >= 3 && expressionHasOperand && !lastElementIsOperand
          && !(display.contains("/0"))
  }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHasResult: Bool {
      return elements.contains("=")
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //This func will call the delegate method to update display in the View Controller:
    func notifyDisplay() {
        delegate?.updateDisplay(text: display)
    }
  
    //  This func will join numbers if several numbers are tapped.
    func joinNumbers(next: String) {
      guard let lastElement = elements.last else { return }
      let newElement = lastElement + next
      elements.removeLast()
      elements.append(newElement)
    }
    
    // View actions
    func tappedNumberButton(number: String) {
      if expressionHasResult  { // If there is already a result, tapping a number will start a new expression:
          elements.removeAll()
          elements.append(number)
      } else if lastElementIsNumber {
          joinNumbers(next: number)
      } else {
          elements.append(number)
      }
      notifyDisplay()
    }
    
    func tappedOperandButton(operand: String) {
        if expressionHasResult { // if there is already a result, we will start a new expression with it:
            if let result = elements.last {
                elements.removeAll()
                elements.append("\(result)")
                elements.append("\(operand)")
                notifyDisplay()
            }
        } else {
            if canAddOperator {
                elements.append("\(operand)")
                notifyDisplay()
            }
        }
    }

    func tappedEqualButton() {
        // First check if the expression is correct and can produce a result otherwise, send an Alert
        guard expressionIsCorrect else {
            delegate?.presentAlert()
            return
        }
        // Then check if there is already a result before performing calcul, otherwise pressing equal does nothing
        if !expressionHasResult  {
            performCalcul()
            notifyDisplay()
            return
        }
    }
    
    // Method linked to Reset Button (AC)
    func reset() {
        elements.removeAll()
        delegate?.updateDisplay(text: "0")
    }
    
    //This is the main algorithm which will produce the result from the expression:
    func performCalcul() {
        var expression = elements
        // Iterate over operations while an operand still here:
        while expression.count > 1 {
            guard let left = Double(expression[0]) else { return }
            guard let right = Double(expression[2]) else { return }
            let operand = expression[1]
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: return
            }
            expression = Array(expression.dropFirst(3))
            expression.insert(formatResult(result), at: 0)
        }
        //Add result to elements to update display
        guard let finalResult = expression.first else { return }
        elements.append("=")
        elements.append("\(finalResult)")
    }
    
    private func formatResult(_ result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let formatedResult = formatter.string(from: NSNumber(value: result)) else { return String() }
        return formatedResult
    }
    

}
