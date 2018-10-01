//
//  ItemTableViewCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
	
	var item: Item?
	@IBOutlet weak var tagsLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var pinImageView: UIImageView!
	@IBOutlet weak var confirmButton: UIButton!
	
	@IBAction func onConfirmButton(_ sender: Any) {
		if let item = item {
			// TODO: Localization
			let itemType = item.amount < 0 ? "expense" : "income"
			let verificationMessage =  item.isVerified ? "Do you want to remove verification from this \(itemType)?" : "Do you verify this \(itemType)?"
			GlobalAlertController.showTwoActionAlert(title: "Verification", message: verificationMessage, preferredStyle: .alert, positiveActionTitle: "Yes", positiveAction: { (_) in
				item.verify()
			}, negativeActionTitle: "No", negativeActionStyle: .cancel)
		}
	}
	
}
