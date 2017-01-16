//
//  DayOptionsTests.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 15/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import XCTest
@testable import WellesleyFresh


class DayOptionsTests: XCTestCase {
	var dayOptions: DayOptions!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		dayOptions = DayOptions(initialDays: ["MTuWe", "ThF"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDoesHaveDays() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		// Given
		let testForDays = ["M", "Tu", "We", "Th", "F"]
		var results = [Bool]()
		let message = "testForDays() function cannot accurately determine if it has a given day"
		
		// When
		for i in 0..<testForDays.count {
			results.append(dayOptions.dayInDayOptions(day: testForDays[i]))
		}
		
		// Then
		for i in 0..<testForDays.count {
			XCTAssert(results[i], message)
		}
    }
	
	func testDoesntHaveDays() {
		// Given
		let testForDays = ["A", "Sa", "Su"]
		var results = [Bool]()
		let message = "testForDafs() function cannot accurately determine if it does not have a given day"
		
		// When
		for i in 0..<testForDays.count {
			results.append(dayOptions.dayInDayOptions(day: testForDays[i]))
		}
		
		// Then
		for i in 0..<results.count {
			XCTAssert(!results[i], message)
		}
	}
    
    func DISABLED_testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
