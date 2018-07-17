//
//  TransportTableViewCell.swift
//  Timetable
//
//  Created by Loud on 7/17/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import UIKit

class TransportTableViewCell: UITableViewCell {

	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var directionLabel: UILabel!
	@IBOutlet weak var routeLabel: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
