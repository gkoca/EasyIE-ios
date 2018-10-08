//
//  FixedTimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 21.07.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class FixedTimelineCell: UITableViewCell {
	
	var item: Item?
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var tagsLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func onConfirmButton(_ sender: UIButton) {
		
	}
	
}
