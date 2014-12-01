//
//  MemoryTests.swift
//  MemoryTests
//
//  Created by Tanya Sahin on 11/22/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit
import XCTest

class MemoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testTimeIntervalExtensionFormattedForMessage() {
        let interval1 : NSTimeInterval = 15
        let interval2 : NSTimeInterval = 65
        let interval3 : NSTimeInterval = 60*60*2
        let interval11 : NSTimeInterval = interval1+interval2+interval3
        let interval12 : NSTimeInterval = interval1+interval3
        
        let interval4 : NSTimeInterval = 0
        
        let interval5 : NSTimeInterval = -10
        
        let interval6 : NSTimeInterval = 60
        let interval7 : NSTimeInterval = (-1)*60*60
        let interval8 : NSTimeInterval = 1.345678909876
        let interval9 : NSTimeInterval = -5.45678
        let interval10 : NSTimeInterval = 38373645454478
        
        XCTAssertEqual(interval1.formattedForMessage(), "15 seconds", "interval1")
        XCTAssertEqual(interval2.formattedForMessage(), "1 min 5 sec", "interval2")
        XCTAssertEqual(interval3.formattedForMessage(), "2h 0m 0s", "interval3")
        XCTAssertEqual(interval11.formattedForMessage(), "2h 1m 20s", "interval11")
        XCTAssertEqual(interval12.formattedForMessage(), "2h 0m 15s", "interval12")
        
        XCTAssertEqual(interval4.formattedForMessage(), "0 seconds", "interval4")
        
        XCTAssertEqual(interval5.formattedForMessage(), "10 seconds", "interval5")
        
        XCTAssertEqual(interval6.formattedForMessage(), "1 min 0 sec", "interval6")
        XCTAssertEqual(interval7.formattedForMessage(), "1h 0m 0s", "interval7")
        XCTAssertEqual(interval8.formattedForMessage(), "1 second", "interval8")
        XCTAssertEqual(interval9.formattedForMessage(), "5 seconds", "interval9")
//        XCTAssertEqual(interval10.formattedHHMMSS(), "10659345959h 34m 37s", "interval10")

    }
    
}
