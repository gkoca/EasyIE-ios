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
				confirmButton.tintColor = item.isVerified ? UIColor.black : Constants.tintColor
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
		if let item = item {
			// TODO: Localization
			let itemType = item.amount < 0 ? "expense" : "income"
			let verificationMessage =  item.isVerified ? "Do you want to remove verification from this \(itemType)?" : "Do you verify this \(itemType)?"
			let verificationWillRemove = "Verification will remove"
			if item.isVerified {
				GlobalAlertController.showTwoActionAlert(title: "Verification", message: verificationMessage, preferredStyle: .alert, positiveActionTitle: "Yes", positiveAction: { (_) in
					GlobalAlertController.showTwoActionAlert(title: "Verification", message: verificationWillRemove, preferredStyle: .alert, positiveActionTitle: "OK", positiveAction: { (_) in
						item.verify()
					}, negativeActionTitle: "Cancel", negativeActionStyle: .cancel)
				}, negativeActionTitle: "No", negativeActionStyle: .cancel)
			} else {
				GlobalAlertController.showTwoActionAlert(title: "Verification", message: verificationMessage, preferredStyle: .alert, positiveActionTitle: "Yes", positiveAction: { (_) in
					item.verify()
				}, negativeActionTitle: "No", negativeActionStyle: .cancel)
			}
		}
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
