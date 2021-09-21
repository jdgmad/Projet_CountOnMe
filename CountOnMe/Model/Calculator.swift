//
//  Calculator.swift
//  CountOnMe
//
//  Created by José DEGUIGNE on 21/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

  import UIKit

  // Define Delegate Protocol to :
  //    - send display data to the View Controller
  //    - display alert message
  protocol DisplayDelegate: AnyObject {
      func updateDisplay(text: String)
      func presentAlert()
  }

  class Calculator: UIViewController {

  // MARK: - Properties
  
  weak var delegate: DisplayDelegate?
  // Array elements of the calcul expression:
  var elements: [String] = []
  // Contains the calc display sent to View Controller by the delegate:
  var display: String {
      return elements.joined()
  }
  // Calculated variables
  var lastElementIsOperand: Bool {
      guard let lastElement = elements.last else { return false }
      return lastElement == "+" || lastElement == "-" || lastElement == "*" || lastElement == "/"
  }
  var lastElementIsNumber: Bool {
      guard let lastElement = display.last else { return false }
      return lastElement.isNumber == true
  }
  var calcExpressionHasOperand: Bool {
      return elements.contains("+") || elements.contains("-") || elements.contains("*")
        || elements.contains("/")
  }
    
  var calcExpressionIsCorrect: Bool {
      return elements.count >= 3 && calcExpressionHasOperand && !lastElementIsOperand
          && !(display.contains("/0"))
  }
    
    var calcExpressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var calcExpressionHasResult: Bool {
      return elements.contains("=")
    }
    
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //This func will call the delegate method to update display in the View Controller
    func notifyDisplay() {
        delegate?.updateDisplay(text: display)
    }
  
    //  This func will concat numbers if several numbers are tapped.
    func concatNumbers(next: String) {
      if let lastElement = elements.last {
        let newElement = lastElement + next
        elements.removeLast()
        elements.append(newElement)
      }
    }
    
    // Actions on number button tapped :
    // Start a new calcul expression if there is already a result display
    // or Concat the numbers with the previous tapped was a number
    // or display the number tapped
    func tappedNumberButton(number: String) {
      // If there is already a result, tapping a number will start a new expression
      if calcExpressionHasResult  {
          elements.removeAll()
          elements.append(number)
      } else if lastElementIsNumber {
          concatNumbers(next: number)
      } else {
          elements.append(number)
      }
      notifyDisplay()
    }
    
    // Actions on operand button tapped :
    // Start a new calc expression with the previous result
    // or add the operand in the array elements
    func tappedOperandButton(operand: String) {
      // if there is already a result, we will start a new expression with it:
      if calcExpressionHasResult {
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
    // Actions on equal button tapped:
    // Check if the calcul expression is correct, if not send an alert
    // Perform the calcul if there is not a previous result
    func tappedEqualButton() {
        if !calcExpressionIsCorrect {
            delegate?.presentAlert()
            return
        }
        if !calcExpressionHasResult  {
            performCalcul()
            notifyDisplay()
            return
        }
    }
    
    // Clear the elements array  on the Reset Button
    // Display "0"
    func reset() {
        elements.removeAll()
        delegate?.updateDisplay(text: "0")
    }
    
    //This is the main algorithm which will produce the result from the expression:
    func performCalcul() {
        var calcExpression = operandPriorities()
        // Iterate over operations while an operand still here:
        while calcExpression.count > 1 {
            guard let left = Double(calcExpression[0]) else { return }
            guard let right = Double(calcExpression[2]) else { return }
            let operand = calcExpression[1]
            let calcResult: Double
            switch operand {
            case "+": calcResult = left + right
            case "-": calcResult = left - right
            default: return
            }
            calcExpression = Array(calcExpression.dropFirst(3))
            //calcExpression.insert(formatResult(calcResult), at: 0)
          calcExpression.insert(calcResult.getStringValue(withFloatingPoints: 2), at: 0)
        }
        //Update the display elements
        if let finalResult = calcExpression.first {
          elements.append("=")
          elements.append("\(finalResult)")
        }
    }
    
    // This func will give the priority to the operation "x" and "/" in the calcul expression
    func operandPriorities() -> [String] {
        var calcExpressionToReduce = elements
        while calcExpressionToReduce.contains("*") || calcExpressionToReduce.contains("/") {
            if let index = calcExpressionToReduce.firstIndex(where: { $0 == "*" || $0 == "/" })  {
                let operand = calcExpressionToReduce[index]
                let calcResult: Double
                if let left = Double(calcExpressionToReduce[index - 1]) {
                    if let right = Double(calcExpressionToReduce[index + 1]) {
                        if operand == "*" {
                            calcResult = left * right
                        } else {
                            calcResult = left / right
                        }
                        //Replacing the elements by the result
                        calcExpressionToReduce.remove(at: index + 1)
                        calcExpressionToReduce.remove(at: index)
                        calcExpressionToReduce.remove(at: index - 1)
                        calcExpressionToReduce.insert(calcResult.getStringValue(withFloatingPoints: 2), at: index - 1)
                    }
                }
            }
        }
        return calcExpressionToReduce
    }
}

extension Double {
  /// Convert double in String with variable decimal points.
  ///
  /// - Parameters:
  ///   - points: Give the numbers of decimal points to display
  ///
  /// If there is no fractionnal part return only the integer part
  func getStringValue(withFloatingPoints points: Int = 0) -> String {
    let valDouble = modf(self)
    // get the fractionnal value
    let fractionalVal = (valDouble.1)
    if fractionalVal > 0 {
      return String(format: "%.*f", points, self)
    }
    return String(format: "%.0f", self)
    }
}
