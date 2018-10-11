//
//  DayInfoTimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 21.07.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class DayInfoTimelineCell: UITableViewCell {
	
	var dayInfo: Day? {
		didSet {
			if let day = dayInfo {
				dayInfoLabel.text = day.description
			}
		}
	}
	var isFirstCell: Bool = false {
		didSet {
			topLine.isHidden = isFirstCell
		}
	}
	@IBOutlet weak var dayInfoLabel: UILabel!
	@IBOutlet weak var topLine: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
