//
//  TimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 2.05.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit
import SnapKit

class TimelineCell: UITableViewCell {
	
	var item: Item? {
		didSet {
			configure()
		}
	}
	
	//infos
	var tagsLabel = UILabel()
	var dateLabel = UILabel()
	var amountLabel = UILabel()
	var detailLabel = UILabel()
	var pinImageView = UIImageView()
	var confirmButton = UIButton()
	
	//ui elements
	var line = UIView()
	var bigDot = UIView()
	var littleDot = UIView()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(tagsLabel)
		addSubview(dateLabel)
		addSubview(amountLabel)
		addSubview(detailLabel)
		addSubview(pinImageView)
		addSubview(confirmButton)
		
		addSubview(line)
		addSubview(bigDot)
		addSubview(littleDot)
		
		confirmButton.addTarget(self, action: #selector(onConfirmButton(_:)), for: .touchUpInside)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@objc func onConfirmButton(_ sender: Any) {
		if let item = item {
			// TODO: Localization
			let itemType = item.amount < 0 ? "expense" : "income"
			let verificationMessage =  item.isVerified ? "Do you want to remove verification from this \(itemType)?" : "Do you verify this \(itemType)?"
			GlobalAlertController.showTwoActionAlert(title: "Verification", message: verificationMessage, preferredStyle: .alert, positifActionTitle: "Yes", positifAction: { (action) in
				item.verify()
			}, negativeActionTitle: "No", negativeActionStyle: .cancel)
		}
	}
	
	func configure() {
		if let item = item {
			
			amountLabel.text = item.amount > 0 ? "+" + String(item.amount) : String(item.amount)
			amountLabel.textColor = item.amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
			let tags = item.tags
				.map { $0.value }
				.joined(separator: " | ")
			
			tagsLabel.text = tags
			
			dateLabel.text = item.date.string(withFormat: "dd MMMM yyyy")
			
			line.backgroundColor = UIColor.AppColor.arrowDark
			line.snp.makeConstraints { (make) in
				make.top.equalTo(contentView)
				make.bottom.equalTo(contentView)
				make.left.equalTo(contentView).offset(28)
				make.size.width.equalTo(2)
				make.size.height.equalTo(contentView)
			}
			
//			dateLabel.snp.makeConstraints { (maker) in
//				maker.left.equalTo(contentView).offset(10)
//				maker.top.equalTo(contentView).offset(10)
//				maker.right.equalTo(contentView)
//			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		}
		
	}
}
