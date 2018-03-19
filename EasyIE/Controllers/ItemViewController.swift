//
//  ItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var entryViewModel: ItemViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 90.0
//		tableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
		
		entryViewModel.loadEntries()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let indexPath = IndexPath(item: entryViewModel.getNumberOfEntriesToDisplay() - 1, section: 0)
//		tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entryViewModel.getNumberOfEntriesToDisplay()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
		let amount = entryViewModel.getEntryAmountAtIndex(indexPath.row)
		
		
		cell.amountLabel.text = amount > 0 ? "+" + String(amount) : String(amount)
		cell.amountLabel.textColor = amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
		var tags = ""
		for tag in entryViewModel.getEntryTagsAtIndex(indexPath.row) {
			tags += tag.value
			tags += " | "
		}
		tags.removeLast(3)
		cell.tagsLabel.text = tags
		cell.dateLabel.text = entryViewModel.getEntryDateStringAtIndex(indexPath.row)
		if entryViewModel.getEntryIsFixedAtIndex(indexPath.row) {
			switch entryViewModel.getEntryCycleTypeAtIndex(indexPath.row) {
			case .undefined:
				fatalError("wrong data, inspect it.")
				break
			case .firstDayOfMonth:
				cell.detailLabel.text = "Fixed : First Day Of Month"
				break
			case .lastDayOfMonth:
				cell.detailLabel.text = "Fixed : Last Day Of Month"
				break
			case .firstWorkDayOfMonth:
				cell.detailLabel.text = "Fixed : First Work Day Of Month"
				break
			case .lastWorkDayOfMonth:
				cell.detailLabel.text = "Fixed : Last Work Day Of Month"
				break
			case .fixedDayOfMonth:
				cell.detailLabel.text = "Fixed : Day of month"
				break
			case .fixedDayOfWeek:
				cell.detailLabel.text = "Fixed : Day of week"
				break
			}
		} else {
			cell.detailLabel.text = ""
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

