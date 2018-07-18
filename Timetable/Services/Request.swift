//
//  Request.swift
//  Timetable
//
//  Created by Loud on 7/17/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import Foundation

class RequestData {
	//request timetable data and return value with handler(dictionary)
	func BeginRequest(handler: @escaping (_ transport_data: Dictionary<String, AnyObject>?) -> Void) -> Void {
		var request = URLRequest(url: URL(string: "http://api.mobile.staging.mfb.io/mobile/v1/network/station/1/timetable")!)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("intervIEW_TOK3n", forHTTPHeaderField: "X-API-Authentication")
		print(request)
		
		let urlSession = URLSession.shared
		let dataTask = urlSession.dataTask(with: request, completionHandler: { data, response, error -> Void in
			print(response!)
			do {
				let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
				print(json)
				handler(json)//return result
			} catch {
				print("error")
			}
		})
		dataTask.resume()
	}
}
