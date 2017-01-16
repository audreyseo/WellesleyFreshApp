//
//  WellesleyFreshTests.swift
//  WellesleyFreshTests
//
//  Created by Audrey Seo on 9/8/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import XCTest
@testable import WellesleyFresh

class NearbyViewControllerTests: XCTestCase {
	var v: NearbyViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
		v = sb.instantiateViewController(withIdentifier: "nearbyVC") as! NearbyViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDoesConvertDegreesToRadians() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		// Given
		let degs:Float = 60.0
		let expectedResult = degs * Float(M_PI / 180.0)
		
		// When
		let actualResult = v.radians(degs)
		
		// Then
		XCTAssert(actualResult == expectedResult, "Does not convert degrees to radians.")
    }
    
	func DISABLED_testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
			
        }
    }
    
}
