//
//  MenuViewControllerTests.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 15/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import XCTest
@testable import WellesleyFresh

class MenuViewControllerTests: XCTestCase {
	var v: MenuViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
		v = sb.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAbsoluteDifference() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		// Given
		let a = 1
		let b = 5
		let expectedResult1 = 4
		let a1 = 10
		let b1 = 4
		let expectedResult2 = 6
		let message = "absDiffInt() function does not find true absolute difference"
		
		// When
		let actualResult1 = v.absDiffInt(val1: a, val2: b)
		let actualResult2 = v.absDiffInt(val1: a1, val2: b1)
		// Then
		XCTAssert(expectedResult1 == actualResult1, message)
		XCTAssert(expectedResult2 == actualResult2, message)
    }
    
    func DISABLED_testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
