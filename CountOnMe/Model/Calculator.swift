//
//  Calculator.swift
//  CountOnMe
//
//  Created by José DEGUIGNE on 21/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

// Define Delegate Protocol to :
//    - send display data to the View Controller
//    - display alert message
protocol DisplayDelegate: AnyObject {
    func updateDisplay(text: String)
    func presentAlert(errorMessage: String)
}

class Calculator {
    
    // MARK: - Properties
    
    weak var delegate: DisplayDelegate?
    
    // Array elements of the calcul expression:
    // At each change update the display
    var elements: [String] = [] {
        didSet {
            delegate?.updateDisplay(text: display)
        }
    }
    // Contains the calc display sent to View Controller by the delegate:
    var display: String {
        return elements.joined()
    }
    
    // Calculated variables
    private var lastElementIsOperand: Bool {
        guard let lastElement = elements.last else { return false }
        return lastElement == "+" || lastElement == "-" || lastElement == "*" || lastElement == "/"
    }
    private var lastElementIsNumber: Bool {
        guard let lastElement = elements.last else { return false }
        return lastElement.isnumber == true
    }
    private var lastElementContainsDot: Bool {
        guard let lastElement = elements.last else { return false }
        return lastElement.contains(".")
    }
    
    private var calcSyntaxExpressionIsCorrect: Bool {
        return calcExpressionHaveEnoughElement && !lastElementIsOperand
        && !(display.contains("/0"))
    }
    
    var errorSyntaxExpression: String {
        //if elements.count < 3 { return "Missing elements" }
        if lastElementIsOperand { return "Last element is operand"}
        if display.contains("/0") { return "Try to divid by zero"}
        return "Missing elements"
    }
    
    // This var return true if the last clacul oveflow.
    // In this case the result of the calcul should be "inf" (infinity)
    private var lastCalculOverFlow: Bool {
        guard let lastElement = elements.last else { return false }
        if lastElement == "inf" {
            return true
        }
        return false
    }
    
    private var calcExpressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var calcExpressionHasResult = false
    
    // MARK: - Methods
    
    //  This func will concat numbers if several numbers are tapped.
    private func concatNumbers(next: String) {
        if let lastElement = elements.last {
            let newElement = lastElement + next
            elements.removeLast()
            elements.append(newElement)
        }
    }
    
    private func changeSignLastNumber() {
        if let lastElement = elements.last {
            guard let lastElementDouble = Double(lastElement) else { return }
            let newElement = lastElementDouble * -1.0
            elements.removeLast()
            elements.append(newElement.getStringValue(withFloatingPoints: 2))
        }
    }
    
    private func applyPoucentageLastNumber() {
        if let lastElement = elements.last {
            guard let lastElementDouble = Double(lastElement) else { return }
            let newElement = lastElementDouble / 100
            elements.removeLast()
            elements.append(newElement.getStringValue(withFloatingPoints: 2))
        }
    }
    // Actions on number button tapped :
    // Start a new calcul expression if there is already a result display
    // or Concat the numbers with the previous tapped was a number
    // or display the number tapped
    func tappedNumberButton(number: String) {
        if calcExpressionHasResult  {
            elements.removeAll()
            elements.append(number)
            calcExpressionHasResult = false
        } else if lastElementIsNumber {
            concatNumbers(next: number)
        } else {
            elements.append(number)
        }
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
            }
            calcExpressionHasResult = false
        } else {
            if !lastElementIsOperand && lastElementIsNumber {
                elements.append("\(operand)")
            }
        }
    }
    // Actions on equal button tapped:
    // Check if the calcul expression is correct, if not send an alert
    // Perform the calcul if there is not a previous result, if yes do nothing
    func tappedEqualButton() {
        if !calcSyntaxExpressionIsCorrect {
            delegate?.presentAlert(errorMessage: errorSyntaxExpression)
            return
        }
        if !calcExpressionHasResult  {
            calculateExpression()
            if lastCalculOverFlow {
                delegate?.presentAlert(errorMessage: "Calcul overflow")
                //reset()
            }
        }
    }
    
    // Change the sign if the last element is a number
    func tappedSignButton() {
        if lastElementIsNumber {
            changeSignLastNumber()
        }
    }
    //
    func tappedPourcentageButton() {
        if lastElementIsNumber {
            applyPoucentageLastNumber()
        }
    }
    
    func tappedDotButton(dot: String) {
        if lastElementIsNumber && !lastElementContainsDot{
            concatNumbers(next: dot)
        }
    }
    
    // Clear the elements array  on the Reset Button
    // Display "0"
    func reset() {
        elements.removeAll()
        delegate?.updateDisplay(text: "0")
    }
    
    //This is the main algorithm which will produce the result from the expression:
    private func calculateExpression() {
        var calcExpression = performOperandPriority()
        // Iterate over operations while an operand still here:
        while calcExpression.count > 1 {
            guard let left = Double(calcExpression[0]) else { return }
            guard let right = Double(calcExpression[2]) else { return }
            let operand = calcExpression[1]
            let calcResult: Double
            if operand == "+" {
                calcResult = left + right
            }
            else {
                calcResult = left - right
            }
            calcExpression = Array(calcExpression.dropFirst(3))
            calcExpression.insert(calcResult.getStringValue(withFloatingPoints: 2), at: 0)
        }
        //Update the display elements
        if let finalResult = calcExpression.first {
            //elements.append("=")
            calcExpressionHasResult = true
            elements.removeAll()
            elements.append("\(finalResult)")
        }
    }
    
    // This func will give the priority to the operation "x" and "/" in the calcul expression
    private func performOperandPriority() -> [String] {
        var calcExpressionToReduce = elements
        // Iterate over calcul Expression while an "x" or "/" operand still here:
        while calcExpressionToReduce.contains("*") || calcExpressionToReduce.contains("/") {
            if let index = calcExpressionToReduce.firstIndex(where: { $0 == "*" || $0 == "/" })  {
                let operand = calcExpressionToReduce[index]
                let calcResult: Double
                if let left = Double(calcExpressionToReduce[index - 1]) {
                    if let right = Double(calcExpressionToReduce[index + 1]) {
                        // Operation multiply
                        if operand == "*" {
                            calcResult = left * right
                            // Operation divid
                        }else {
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
    
    /// Convert double in String with variable decimal points or exponant
    ///
    /// - Parameters:
    ///   - points: Give the numbers of decimal points to display
    ///
    /// If the number is over or les than 10 billions use the exponant format
    /// Otherwise If there is no fractionnal part return only the integer part
    ///
    func getStringValue(withFloatingPoints points: Int = 0) -> String {
        if self < 10000000000 && self > -10000000000 {
            let valDouble = modf(self)
            // get the fractionnal value
            let fractionalVal = (valDouble.1)
            if fractionalVal != 0 {
                return String(format: "%.*f", points, self)
            }
            return String(format: "%.0f", self)
        }
        return String(format: "%.*e", points, self)
    }
}

extension String {
    var isnumber: Bool {
        return Double(self) != nil
    }
}
