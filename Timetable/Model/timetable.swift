//
//  timetable.swift
//  Timetable
//
//  Created by Loud on 7/17/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import Foundation
import Gloss

struct DateAndTime : JSONDecodable {
	let timestamp : Date?
	let tz : String?
	
	init?(json: JSON) {
		self.timestamp = "timestamp" <~~ json
		self.tz = "tz" <~~ json
	}
}

struct Route : JSONDecodable {
	let name : String?
	
	init?(json: JSON) {
		self.name = "name" <~~ json
	}
}

struct Arrivals : JSONDecodable {
	let route:[Route]?
	let direction : String?
	let lineCode : String?
	let dateTime : DateAndTime?

	init?(json: JSON) {
		self.direction = "line_direction" <~~ json
		self.lineCode = "line_code" <~~ json
		self.dateTime = "datetime" <~~ json
		
		guard let list_values = [Route].from(jsonArray: ("route" <~~ json)!) else {
			// handle decoding failure here
			return nil
		}
		self.route = list_values
	}
}

struct TimetableData: JSONDecodable {
	let arrivals: [Arrivals]?
	
	init?(json: JSON) {
		//self.arrivals = "timetable.arrivals" <~~ json
		guard let list_values = [Arrivals].from(jsonArray: ("timetable.arrivals" <~~ json)!) else {
			// handle decoding failure here
			return nil
		}
		self.arrivals = list_values
	}
}
