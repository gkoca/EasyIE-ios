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
				confirmButton.setImage(item.isVerified ? #imageLiteral(resourceName: "verified circle") : #imageLiteral(resourceName: "unverified circle"), for: .normal)
				setCycleDescription(of: item)
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
	
	// MARK: - Private
	private func setCycleDescription(of item: Item) {
		if let type = DateCycleType(rawValue: item.cycleType) {
			switch type {
			case .undefined:
				fatalError("wrong data, inspect it.")
			case .firstDayOfMonth:
				detailLabel.text = "Every first day of month"
			case .lastDayOfMonth:
				detailLabel.text = "Every last day of month"
			case .firstWorkDayOfMonth:
				detailLabel.text = "Every first work Day Of month"
			case .lastWorkDayOfMonth:
				detailLabel.text = "Every last work day of month"
			case .fixedDayOfMonth:
				let numberFormatter = NumberFormatter()
				numberFormatter.numberStyle = .ordinal
				let ordinal = numberFormatter.string(from: NSNumber(value: item.cycleValue))
				detailLabel.text = "Every \(ordinal ?? "??") day of month"
			case .fixedDayOfWeek:
				detailLabel.text = "Every \(Constants.namesOfDays[item.cycleValue])"
			}
		}
		
	}
}
