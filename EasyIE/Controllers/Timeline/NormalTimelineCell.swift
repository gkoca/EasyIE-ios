//
//  NormalTimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 21.07.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class NormalTimelineCell: UITableViewCell {
	
	var item: Item?
	
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var tagsLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
