//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by José DEGUIGNE on 21/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest

@testable import CountOnMe

class CalculatorTests: XCTestCase {
  
  var calcTest: Calculator!
  
  override func setUp() {
    super.setUp()
    calcTest = Calculator()
  }

  func setNumberTapped(_ paramNumber: String) {
    calcTest.tappedNumberButton(number: paramNumber)
  }
  
  func setOperandTapped(_ paramOperand: String) {
    calcTest.tappedNumberButton(number: paramOperand)
  }
  
  func setEqualTapped() {
    calcTest.tappedEqualButton()
  }
  
  
  // MARK: Testing display
  
  func testGivenElementsIsEmpty_WhenAddingElement_ThenDisplayReturnsJoinedString() {
    
      setNumberTapped("1")
      setOperandTapped("+")
      setNumberTapped("2")
    
      XCTAssertTrue(calcTest.display == "1+2")
  }
  
  // MARK: - Testing tappedNumberButton()

  func testGivenElementsIsEmpty_WhenForcingFuncWithParameter7_ThenElementsContains7() {
    
      setNumberTapped("7")
    
      XCTAssertTrue(calcTest.elements == ["7"])
  }
  
  func testGivenElementsIs2_WhenForcingFuncWithparameter3_ThenElementsContains23() {
    
      setNumberTapped("2")
    
      setNumberTapped("3")
    
      XCTAssertTrue(calcTest.elements == ["23"])
  }
  
func testGivenAnCalcExpressionWithResult_WhenForcingFuncWithParameter6_ThenElementIs6() {
    
    setNumberTapped("2")
    setOperandTapped("+")
    setNumberTapped("3")
    setEqualTapped()
    
    setNumberTapped("6")
    print(calcTest.display)
    XCTAssertTrue(calcTest.display == "6")
  }
   
  
    
  // MARK: - Testing reset()
  func testGivenAnExpression_WhenTriggeringFunctionReset_ThenElementsIsEmpty() {
      setNumberTapped("2")
      calcTest.reset()
      XCTAssertTrue(calcTest.elements.isEmpty)
  }

  // MARK: - Testing operandButton()

  func testGivenExpressionHasResult_WhenTriggerringFunc_ThenElementsContainsResultWithOperand() {
      setNumberTapped("1")
      setNumberTapped("2")
      setOperandTapped("-")
      setNumberTapped("9")
      setEqualTapped()
      setOperandTapped("-")
      print(calcTest.display)
      XCTAssertTrue(calcTest.elements == ["3", "-"])
  }

  // MARK: - Testing equalButton()

  func testGivenACorrectExpression_WhenTriggerringFunc_ThenExpressionGetsResult() {
      setNumberTapped("3")
      setOperandTapped("*")
      setNumberTapped("2")
      setEqualTapped()
      print(calcTest.display)
      XCTAssertTrue(calcTest.display == "3*2=6")
  }
  func testGivenAnIncorrectExpression_WhenTriggerringFunc_ThenExpressionDoesntChange() {
      setNumberTapped("5")
      setOperandTapped("*")
      setNumberTapped("2")
      setOperandTapped("*")
      setEqualTapped()
    print(calcTest.display)
      XCTAssertTrue(calcTest.elements == ["5", "*", "2", "*"])
  }
  func testGivenLastElementIsOperand_WhenTriggerringFunc_ThenElementsDoesntChange() {
      setNumberTapped("3")
      setOperandTapped("*")
    print(calcTest.display)
      XCTAssertTrue(calcTest.elements == ["3", "*"])
  }


  
  
  
  
}
