//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Давид Бекоев on 19.06.2024.
//

import XCTest

 class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
     
     
             func testYesButton() {
         sleep(3)
       //  Поэтому для проверки картинок можно предложить такое решение:
         let firstPoster = app.images["Poster"] // находим первоначальный постер
         let firstPosterData = firstPoster.screenshot().pngRepresentation
           
         app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
         sleep(3)
         let secondPoster = app.images["Poster"]  // ещё раз находим постер
         let secondPosterData = secondPoster.screenshot().pngRepresentation
        // XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
                 let indexLabel = app.staticTexts["Index"]
           XCTAssertNotEqual(firstPosterData, secondPosterData)
            XCTAssertEqual(indexLabel.label, "2/10")
     }
         
     func testNoButton() {
         sleep(3)
         let firstPoster = app.images["Poster"]
         let firstPosterData = firstPoster.screenshot().pngRepresentation
         app.buttons["No"].tap()
         sleep(3)
            
            let secondPoster = app.images["Poster"]
            let secondPosterData = secondPoster.screenshot().pngRepresentation

            let indexLabel = app.staticTexts["Index"]
           
            XCTAssertNotEqual(firstPosterData, secondPosterData)
            XCTAssertEqual(indexLabel.label, "2/10")
     }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
