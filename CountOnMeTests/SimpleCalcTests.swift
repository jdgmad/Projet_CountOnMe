//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest

@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
  
  var calcTest = Calculator()

  // MARK: Testing display
  
  func testGivenElementsIsEmpty_WhenAddingElement_ThenDisplayReturnsJoinedString() {
      calcTest.tappedNumberButton(number: "1")
      calcTest.tappedOperandButton(operand: "+")
      calcTest.tappedNumberButton(number: "2")
      XCTAssertTrue(calcTest.display == "1+2")
  }

}

/*
// MARK: - Testing reset()

func testGivenAnExpression_WhenTriggeringFunctionReset_ThenElementsIsEmpty() {
    sut.numberButton(number: "5")
    sut.reset()
    XCTAssertTrue(sut.elements.isEmpty)
}

// MARK: - Testing equalButton()

func testGivenElementsHasACorrectExpression1_WhenPerformingCalcul_ThenElementsContainsCorrectResult() {
    sut.numberButton(number: "5")
    sut.operandButton(operand: "+")
    sut.numberButton(number: "2")
    sut.operandButton(operand: "*")
    sut.numberButton(number: "2")
    sut.equalButton()
    XCTAssert(sut.elements == ["5", "+", "2", "*", "2", "=", "9"])
}

func testGivenElementsHasACorrectExpression3_WhenPerformingCalcul_ThenElementsContainsCorrectResult() {
    sut.numberButton(number: "3")
    sut.operandButton(operand: "/")
    sut.numberButton(number: "2")
    sut.equalButton()
    XCTAssert(sut.elements == ["3", "/", "2", "=", "1.5"])
}

// MARK: - Testing numberButton()

func testGivenElementsIsEmpty_WhenTriggeringFuncWithParameter5_ThenElementsContains5() {
    sut.numberButton(number: "5")
    XCTAssertTrue(sut.elements == ["5"])
}
func testGivenAnExpressionWithResult_WhenTriggeringFuncWithParameter3_ThenLastElementIs3() {
    sut.numberButton(number: "2")
    sut.operandButton(operand: "+")
    sut.numberButton(number: "3")
    sut.equalButton()
    sut.numberButton(number: "3")
    XCTAssertTrue(sut.display == "3")
}

// MARK: - Testing operandButton()

func testGivenExpressionHasResult_WhenTriggerringFunc_ThenElementsContainsResultWithOperand() {
    sut.numberButton(number: "1")
    sut.numberButton(number: "2")
    sut.operandButton(operand: "-")
    sut.numberButton(number: "9")
    sut.equalButton()
    sut.operandButton(operand: "-")
    XCTAssertTrue(sut.elements == ["3", "-"])
}

// MARK: - Testing equalButton()

func testGivenACorrectExpression_WhenTriggerringFunc_ThenExpressionGetsResult() {
    sut.numberButton(number: "3")
    sut.operandButton(operand: "*")
    sut.numberButton(number: "2")
    sut.equalButton()
    XCTAssertTrue(sut.display == "3*2=6")
}
func testGivenAnIncorrectExpression_WhenTriggerringFunc_ThenExpressionDoesntChange() {
    sut.numberButton(number: "5")
    sut.operandButton(operand: "*")
    sut.numberButton(number: "2")
    sut.operandButton(operand: "+")
    sut.equalButton()
    XCTAssertTrue(sut.elements == ["5", "*", "2", "+"])
}
func testGivenLastElementIsOperand_WhenTriggerringFunc_ThenElementsDoesntChange() {
    sut.numberButton(number: "3")
    sut.operandButton(operand: "*")
    XCTAssertTrue(sut.elements == ["3", "*"])
}
}
 */
