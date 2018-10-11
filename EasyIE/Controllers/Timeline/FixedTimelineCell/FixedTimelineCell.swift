//
//  FixedTimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 21.07.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class FixedTimelineCell: UITableViewCell {
	
	var item: Item? {
		didSet {
			if let item = item {
				amountLabel.text = item.amount > 0 ? "+" + String(item.amount) : String(item.amount)
				amountLabel.textColor = item.amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
				let tags = item.tags
					.map { $0.value }
					.joined(separator: " | ")
				tagsLabel.text = tags
				detailLabel.text = item.date.string(withFormat: "dd MMMM yyyy")
			}
			
		}
	}
	var isLastCell: Bool = false {
		didSet {
			bottomLine.isHidden = isLastCell
		}
	}
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var tagsLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var bottomLine: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func onConfirmButton(_ sender: UIButton) {
		
	}
	
}
