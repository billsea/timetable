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
	var dateLabel : UILabel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
			
			self.title = "Arrivals"
			
			topButton = UIBarButtonItem(title: "Depart", style: .done, target: self, action: #selector(rightButtonAction))
			
			self.navigationItem.rightBarButtonItem = topButton
			
			dateLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 41))
			dateLabel?.text = "Date:"
			
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
		
		//MARK: Begin REST Request
		RequestData().BeginRequest() { (json_result) -> Void in
			//Swift async call
			DispatchQueue.main.async() {
				//parse JSON result
				if(type == TransportType.ARRIVAL.rawValue){
					self.transportData = TimetableArrivals.init(json: json_result!)?.arrivals
					self.title = "Arrivals"
					self.topButton?.title = "Depart"
				} else {
					self.transportData = TimetableDepartures.init(json: json_result!)?.departures
					self.title = "Departures"
					self.topButton?.title = "Arrive"
			  }
				self.tableView.reloadData()
			}
		}
		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return  self.transportData?.count ?? 0
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransportTableViewCell
			
			let transport  = self.transportData![indexPath.row] as Transport
			
			cell.directionLabel.text = transport.direction
			cell.routeLabel.text = transport.throughStations
			
			if let dt = transport.dateTime?.timestamp {
				cell.timeLabel.text = formatDate(inDate: dt, format: "HH:mm")
				self.dateLabel?.text = "Date: " + formatDate(inDate: dt, format: "MM-DD-YYYY") + String(indexPath.row)
			}
			return cell
    }
	
		override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
			return 50
		}
	
		override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
			let vw = UIView()
			vw.backgroundColor = UIColor.lightGray
			vw.addSubview(dateLabel!)
			return vw
		}
	
	func formatDate(inDate : Double, format : String) -> String {
			let formatter = DateFormatter()
			formatter.dateFormat = format
			return formatter.string(from: NSDate.init(timeIntervalSinceReferenceDate: inDate) as Date)
		}
    
}
