//
//  ExtensionXCTestCase.swift
//  GAN_for_IOSUITests
//
//  Created by Valery Shestakov on 07.06.2022.
//

import UIKit
import XCTest

extension XCTestCase {
    /// Ожидание элемента
    func waitFor<T>(object: T,
                    timeout: TimeInterval = 5,
                    file: String = #file,
                    line: UInt = #line,
                    expectationPredicate: @escaping (T?) -> Bool) {
        let predicate = NSPredicate { obj, _ in
            expectationPredicate(obj as? T)
        }
        
        expectation(for: predicate, evaluatedWith: object, handler: nil)
        
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let message = "Failed to fulful expectation block for \(object) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
    
    func waitForElementToAppear(element: XCUIElement,
                                timeout seconds: TimeInterval = 5,
                                file: String = #file,
                                line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        XCTWaiter().wait(for: [expectation], timeout: seconds)
        XCTAssert(element.exists, "Element \(element.identifier) not found")
    }
    
    func waitForEitherElementToExist(_ first: XCUIElement, _ second: XCUIElement) {
        let startTime = NSDate.timeIntervalSinceReferenceDate
        while !first.exists && !second.exists {
            if NSDate.timeIntervalSinceReferenceDate - startTime > 60.0 {
                XCTFail("Timed out waiting for either element to exist.")
                break
            }
            sleep(1)
        }
    }
    
    func checkThat(_ state: Bool) {
        XCTAssert(state)
    }
    
    func checkNot(_ state: Bool) {
        XCTAssertFalse(state)
    }
    
}

extension XCUIElement {
    /// Ожидание элемента
    func waitDisplayed() {
        XCTestCase().waitFor(object: self, timeout: 60.0) {  $0?.exists == true }
        XCTAssert(self.exists)
    }
    
    /// Ожидание отсутствия элемента на экране
    func waitGone() {
        XCTestCase().waitFor(object: self, timeout: 60.0) {  $0?.exists == false }
        XCTAssertFalse(self.exists)
    }
    
    /// Ожидание возможности кликнуть по элементу
    func waitClickable() {
        XCTestCase().waitFor(object: self, timeout: 60.0) {  $0?.isHittable == true }
        XCTAssert(self.isHittable)
    }
    
    func unClickable() {
        XCTAssert(self.isEnabled)
    }
}

