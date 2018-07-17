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
	let timestamp : Double?
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

struct Transport : JSONDecodable {
	let route:[Route]?
	let direction : String?
	let lineCode : String?
	let dateTime : DateAndTime?
	let throughStations : String?

	init?(json: JSON) {
		self.direction = "line_direction" <~~ json
		self.lineCode = "line_code" <~~ json
		self.dateTime = "datetime" <~~ json
		self.throughStations = "through_the_stations" <~~ json
		
		guard let list_values = [Route].from(jsonArray: ("route" <~~ json)!) else {
			return nil
		}
		self.route = list_values
	}
}

struct TimetableArrivals: JSONDecodable {
	let arrivals: [Transport]?
	
	init?(json: JSON) {
		guard let list_values = [Transport].from(jsonArray: ("timetable.arrivals" <~~ json)!) else {
			return nil
		}
		self.arrivals = list_values
	}
}

struct TimetableDepartures: JSONDecodable {
	let departures: [Transport]?
	
	init?(json: JSON) {
		guard let list_values = [Transport].from(jsonArray: ("timetable.departures" <~~ json)!) else {
			return nil
		}
		self.departures = list_values
	}
}
