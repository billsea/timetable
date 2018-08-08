//
//  TimetableTableViewController.swift
//  Timetable
//
//  Created by Loud on 7/17/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

enum TransportType : Int {
	case ARRIVAL
	case DEPARTURE
}

class TimetableTableViewController: UITableViewController {
	
	var transportData:[Transport]?
	var topButton : UIBarButtonItem?
	var dateSections = Array<Any>()
	var dateSectionDates = [String]()
	var alertController : UIAlertController!
	
	override func viewDidLoad() {
			super.viewDidLoad()
		
		self.title = "Arrivals"
		
		topButton = UIBarButtonItem(title: "Depart", style: .done, target: self, action: #selector(rightButtonAction))
		
		self.navigationItem.rightBarButtonItem = topButton
		
		self.dataRequest(type: TransportType.ARRIVAL.rawValue)
		
		// Register cell classes
		tableView.register(UINib(nibName: "TransportTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
	}

	@objc func rightButtonAction(sender: AnyObject) {
		let snd = sender as! UIBarButtonItem
		
		if(snd.title == "Depart"){
			self.dataRequest(type: TransportType.DEPARTURE.rawValue)
		} else {
			self.dataRequest(type: TransportType.ARRIVAL.rawValue)
		}
	}
	
	func dataRequest( type : Int){
		self.showProgressAlert()
		
		//MARK: Begin REST Request
		RequestData().BeginRequest() { (json_result) -> Void in
			//Swift async call
			DispatchQueue.main.async() {
				//parse JSON result
				guard let json_result = json_result else {
					return
				}
				if(type == TransportType.ARRIVAL.rawValue){
					self.transportData = TimetableArrivals.init(json: json_result)?.arrivals
					self.title = "Arrivals"
					self.topButton?.title = "Depart"
				} else {
					self.transportData = TimetableDepartures.init(json: json_result)?.departures
					self.title = "Departures"
					self.topButton?.title = "Arrive"
			  }
				self.loadDateSections()
				self.tableView.reloadData()
				self.alertController.dismiss(animated: true, completion: nil);
			}
		}
	}
	
	func loadDateSections(){
		dateSections.removeAll()
		var lastdate : String?
		var group = [Transport]()
		
		guard let transportData = self.transportData else {
			return
		}
		
		for var t in transportData {
			let curdate = formatDate(inDate: (t.dateTime?.timestamp)!, format: "dd-MM-YY",timezone: (t.dateTime?.tz)!)
			if(lastdate == nil){
				group.append(t)
				lastdate = curdate
				dateSectionDates.append(curdate)
			} else if (curdate == lastdate){
				//add to existing group
				group.append(t)
				lastdate = curdate
			} else if (curdate != lastdate){
				//start new group
				dateSections.append(group)
				group.removeAll()
				lastdate = curdate
				dateSectionDates.append(curdate)
			}
		}
		dateSections.append(group)
	}
	
	func showProgressAlert() {
		alertController = UIAlertController(title: nil, message: "Loading...\n\n", preferredStyle: .alert)
		alertController.view.backgroundColor = UIColor.clear
		
		let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		
		let spinX = (alertController.view.frame.size.width/2) - (spinnerIndicator.frame.size.width/2)
		spinnerIndicator.center = CGPoint(x: spinX-50, y: 65.5)
		spinnerIndicator.color = UIColor.black
		spinnerIndicator.startAnimating()
		
		alertController.view.addSubview(spinnerIndicator)
		self.present(alertController, animated: false, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}

	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
			return dateSections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let transportSection  = self.dateSections[section] as! [Transport]
		return  transportSection.count
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransportTableViewCell
		
		let transportSection  = self.dateSections[indexPath.section] as! [Transport]
		let transport  = transportSection[indexPath.row]
	
		cell.directionLabel.text = transport.direction
		cell.routeLabel.text = transport.throughStations

		if let dt = transport.dateTime?.timestamp {
			cell.timeLabel.text = formatDate(inDate: dt, format: "HH:mm", timezone: (transport.dateTime?.tz)!)
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
		return 50
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.dateSectionDates[section]
	}
	
	func formatDate(inDate : Double, format : String, timezone : String) -> String {
			let date = Date(timeIntervalSince1970: inDate)
			let dateFormatter = DateFormatter()
			dateFormatter.timeZone = TimeZone(abbreviation: timezone)
			dateFormatter.locale = NSLocale.current
			dateFormatter.dateFormat = format
			return dateFormatter.string(from: date)
		}

    
}
