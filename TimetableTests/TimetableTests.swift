//
//  TimetableTests.swift
//  TimetableTests
//
//  Created by Loud on 7/17/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import XCTest
@testable import Timetable

class TimetableTests: XCTestCase {
	
	let timetable = TimetableTableViewController()
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
		func testRequest() {
			//TODO - all tests should have the potential to succeed or fail
			timetable.dataRequest(type: 0)
			timetable.loadDateSections()
		}
	
		func testRestRequest(){
			let type  = 0
			
			RequestData().BeginRequest() { (json_result) -> Void in
				//Swift async call
				DispatchQueue.main.async() {
					//parse JSON result
					guard let json_result = json_result else {
						return
					}
					if(type == TransportType.ARRIVAL.rawValue){
						let arrivalData = TimetableArrivals.init(json: json_result)?.arrivals
						XCTAssert(arrivalData != nil)
					} else {
						let departureData = TimetableDepartures.init(json: json_result)?.departures
						XCTAssert(departureData != nil)
					}
				}
			}
		}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
