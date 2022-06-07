//
//  GAN_for_IOSUITests.swift
//  GAN_for_IOSUITests
//
//  Created by Valery Shestakov on 07.06.2022.
//

import XCTest

class MainScreenUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        UIApplication.shared.keyWindow?.layer.speed = 100
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func restartApp() {
        app.terminate()
        app.activate()
    }
    
    func tapAtPosition(position: CGPoint,
                       file: String = #file,
                       line: UInt = #line) {
        let cooridnate = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: position.x, dy: position.y))
        cooridnate.tap()
    }
    
    func selectPhotoFromGalary() {
        waitForElementToAppear(element: app.buttons["Photos"], timeout: 10)
        let position = CGPoint(x: 100.0, y: 150.0)
        tapAtPosition(position: position)
        let chooseButton = app.buttons["Choose"]
        waitForElementToAppear(element: chooseButton, timeout: 5)
        chooseButton.tap()
    }
    
    func testFirst() {
        // UI tests must launch the application that they test.
        app.launch()
        app.images["default_image"].firstMatch.waitDisplayed()
        app.images["logo"].firstMatch.waitDisplayed()
        checkThat(app.buttons.staticTexts["Choose Photo"].firstMatch.exists)
        checkThat(app.buttons.staticTexts["Save Image"].firstMatch.exists)
        checkThat(app.buttons.staticTexts["Ganerate Image"].firstMatch.exists)
        
        app.buttons.staticTexts["Choose Photo"].firstMatch.waitClickable()
        app.buttons.staticTexts["Save Image"].firstMatch.unClickable()
        app.buttons.staticTexts["Ganerate Image"].firstMatch.unClickable()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSecond() {
        app.launch()
        app.buttons.staticTexts["Choose Photo"].firstMatch.tap()
        app.buttons["Camera"].firstMatch.waitDisplayed()
        app.buttons["Gallery"].firstMatch.waitDisplayed()
        app.buttons["Cancel"].firstMatch.waitDisplayed()
    }
    
    func testThree() {
        app.launch()
        app.buttons.staticTexts["Choose Photo"].firstMatch.tap()
        app.buttons["Gallery"].firstMatch.tap()
        selectPhotoFromGalary()
        app.buttons.staticTexts["Ganerate Image"].firstMatch.waitClickable()
        app.buttons.staticTexts["Save Image"].firstMatch.unClickable()
        app.buttons.staticTexts["Choose Photo"].firstMatch.waitClickable()
    }
    
    func testFour() {
        app.launch()
        app.buttons.staticTexts["Choose Photo"].firstMatch.tap()
        app.buttons["Gallery"].firstMatch.tap()
        selectPhotoFromGalary()
        app.buttons["Ganerate Image"].firstMatch.tap()
        app.buttons.staticTexts["Choose Photo"].firstMatch.waitClickable()
        app.buttons.staticTexts["Save Image"].firstMatch.waitClickable()
        app.buttons.staticTexts["Ganerate Image"].firstMatch.unClickable()
        
    }

}
