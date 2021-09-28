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
  let maxDouble = Double.greatestFiniteMagnitude
  
  override func setUp() {
    super.setUp()
    calcTest = Calculator()
  }

  func setNumberTapped(_ paramNumber: String) {
    calcTest.tappedNumberButton(number: paramNumber)
  }
  
  func setOperandTapped(_ paramOperand: String) {
    calcTest.tappedOperandButton(operand: paramOperand)
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

  func testGivenElementsIsEmpty_WhentappedNumber7_ThenElementsContains7() {
    
      setNumberTapped("7")
    
      XCTAssertTrue(calcTest.elements == ["7"])
  }
  
  func testGivenElementsIs2_WhentappedNumber3_ThenElementsContains23() {
    
      setNumberTapped("2")
    
      setNumberTapped("3")
    
      XCTAssertTrue(calcTest.elements == ["23"])
  }
 
  func testGivenAnCalcExpressionWithResult_WhentappedNumber6_ThenElementIs6() {

    setNumberTapped("8")
    setOperandTapped("/")
    setNumberTapped("2")
    setEqualTapped()
    
    setNumberTapped("6")
  
    XCTAssertTrue(calcTest.display == "6")
  }
   
  

  // MARK: - Testing reset()
  func testGivenAnExpression_WhenTriggeringFunctionReset_ThenElementsIsEmpty() {
      setNumberTapped("2")
      calcTest.reset()
      XCTAssertTrue(calcTest.elements.isEmpty)
  }

  // MARK: - Testing operandButton()

  func testGivenExpressionHasResult_WhentappedOperand_ThenElementsContainsResultWithOperand() {
      setNumberTapped("1")
      setNumberTapped("2")
      setOperandTapped("-")
      setNumberTapped("9")
      setEqualTapped()
    
      setOperandTapped("-")

      XCTAssertTrue(calcTest.elements == ["3", "-"])
  }

  // MARK: - Testing equalButton()
  
  func testGivenLastElementIsOperand_WhenEqualIstapped_ThenElementsDoesntChange() {
      setNumberTapped("3")
    
      setEqualTapped()

      XCTAssertTrue(calcTest.elements == ["3"])
      XCTAssertTrue(calcTest.errorSyntaxExpression == "Missing elements")
  }

  func testGivenACorrectExpression_WhenEqualIstapped_ThenExpressionGetsResult() {
      setNumberTapped("3")
      setOperandTapped("*")
      setNumberTapped("2")
    
      setEqualTapped()
    
      XCTAssertTrue(calcTest.display == "6")
  }
  
  func testGivenExpressionHasAResult_WhenEqualIstapped_ThenExpressionDoesntChange() {
      setNumberTapped("7")
      setOperandTapped("/")
      setNumberTapped("2")
      setEqualTapped()
    
      setEqualTapped()
    
      XCTAssertTrue(calcTest.display == "3.50")
  }
  
  func testGivenAnIncorrectExpression_WhenEqualIstapped_ThenExpressionDoesntChange() {
      setNumberTapped("9")
      setOperandTapped("*")
      setNumberTapped("3")
      setOperandTapped("*")
    
      setEqualTapped()

      XCTAssertTrue(calcTest.elements == ["9", "*", "3", "*"])
  }
  
  func testGivenComplexExpression_WhenEqualIsTapped_ThenOperandPriorityIsRespected() {
      setNumberTapped("2")
      setOperandTapped("+")
      setNumberTapped("5")
      setOperandTapped("*")
      setNumberTapped("4")
  
      setEqualTapped()

      XCTAssertTrue(calcTest.elements == ["22"])
  }
  
  func testGivenNumberIsOver10000000000_WhenEqualIsTapped_ThenDisplayExponantFormat() {
      setNumberTapped("10000000000")
      setOperandTapped("+")
      setNumberTapped("1")
    
      setEqualTapped()
    
      XCTAssertEqual(calcTest.elements.last, "1.00e+10")
    
  }
  
  
  func testGivenExpressionContainsLargeNummber_WhenEqualIsTapped_ThenresultIsSetTo0() {
      setNumberTapped("1.80e+308")
      setOperandTapped("*")
      setNumberTapped("10")
    
      setEqualTapped()
    
      //XCTAssertTrue(calcTest.elements.last == "inf")
      XCTAssertEqual(calcTest.elements.last, "inf")
    
  }
  
  
  // MARK: - Testing sign button
  
  func testGivenLastElementIsNumber_WhenSigneButtonIsTapped_ThenNumberChangedSign() {
    setNumberTapped("7")
    
    calcTest.tappedSignButton()
    
    XCTAssertTrue(calcTest.elements == ["-7"])
  }
 
  // MARK: - Testing pourcentage Button
  
  func testGivenLastElementIsNumber_WhenPourcentageButtonIsTapped_ThenNumberIsDivededBy100() {
    setNumberTapped("3")
    setNumberTapped("5")
    
    calcTest.tappedPourcentageButton()
    
    XCTAssertTrue(calcTest.elements == ["0.35"])
  }
  
  // MARK: - Testing Dot Button
  
  func testGivenLastElementIsNumber_WhenDotButtonIsTapped_ThenNumberIsDecimal() {
    setNumberTapped("3")
    setNumberTapped("9")
    
    calcTest.tappedDotButton(dot: ".")
    setNumberTapped("5")
    
    XCTAssertTrue(calcTest.elements == ["39.5"])
  }
  
  
  // MARK: - Testing error message
  
  func testGivenDividExpressionby0_WhenEqualIsTaped_ThenErrorSyntaxExpression() {
    setNumberTapped("9")
    setOperandTapped("/")
    setNumberTapped("0")
    
    setEqualTapped()
    
    XCTAssertTrue(calcTest.errorSyntaxExpression == "Try to divid by zero")
  }
}
