//
//  ItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {
	
	@IBOutlet var itemViewModel: ItemViewModel!
		
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 90.0
		itemViewModel.loadItems()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if itemViewModel.getNumberOfPeriodsToDisplay() > 0 && itemViewModel.itemViewNeedsUpdate {
			tableView.reloadData()
			if let lastPeriod = itemViewModel.getKeysOfPeriodicItems().last {
				let indexPath = IndexPath(row: itemViewModel.getNumberOfItemsInPeriod(period: lastPeriod) - 1, section: itemViewModel.getNumberOfPeriodsToDisplay() - 1)
				Dispatch.main {
					self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
				}
			}
			itemViewModel.itemViewNeedsUpdate = false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddItemVCSegue" {
			if let addItemNavVC = segue.destination as? UINavigationController {
				if let addItemVC = addItemNavVC.viewControllers.first as? AddItemViewController {
					addItemVC.parentVC = self
				}
			}
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func getPast(_ sender: UIRefreshControl) {
		Dispatch.main(after: 1.0) {
			let periods = self.itemViewModel.getKeysOfPeriodicItems()
			if periods.count > 0 {
				let currentFirst = self.itemViewModel.getKeysOfPeriodicItems()[0]
				if self.itemViewModel.canGetOnePast(of: currentFirst) {
					self.tableView.reloadData()
				}
			}
			sender.endRefreshing()
		}
	}
}

extension ItemViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return itemViewModel.getNumberOfPeriodsToDisplay()
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return itemViewModel.getKeysOfPeriodicItems()[section].description
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let period = itemViewModel.getPeriodAtSection(section: section)
		return itemViewModel.getNumberOfItemsInPeriod(period: period)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let period = itemViewModel.getPeriodAtSection(section: indexPath.section)
		let index = indexPath.row
		let item = itemViewModel.getItemAtPeriodAndIndex(period: period, index: index)
		let amount = item.amount
		let itemIsFixed = item.isFixed
		let itemIsConfirmed = item.isVerified
		let cycleType = DateCycleType(rawValue: item.cycleType)!
		let cycleValue = item.cycleValue
		let tags = item.tags
			.map { $0.value }
			.joined(separator: " | ")
		
//		let cell = TimelineCell(style: .default, reuseIdentifier: "timeLineCell")
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
		cell.item = item
		
		
		cell.amountLabel.text = amount > 0 ? "+" + String(amount) : String(amount)
		cell.amountLabel.textColor = amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
		cell.tagsLabel.text = tags
		cell.dateLabel.text = item.date.string(withFormat: "dd MMMM yyyy")
		//TODO: Localization
		if itemIsFixed {
			cell.pinImageView.isHidden = false
			cell.confirmButton.isHidden = false
			cell.confirmButton.setImage(itemIsConfirmed ? #imageLiteral(resourceName: "verified") : #imageLiteral(resourceName: "unverified"), for: .normal)
			switch cycleType {
			case .undefined:
				fatalError("wrong data, inspect it.")
				break
			case .firstDayOfMonth:
				cell.detailLabel.text = "Every first day of month"
				break
			case .lastDayOfMonth:
				cell.detailLabel.text = "Every last day of month"
				break
			case .firstWorkDayOfMonth:
				cell.detailLabel.text = "Every first work Day Of month"
				break
			case .lastWorkDayOfMonth:
				cell.detailLabel.text = "Every last work day of month"
				break
			case .fixedDayOfMonth:
				let numberFormatter = NumberFormatter()
				numberFormatter.numberStyle = .ordinal
				let ordinal = numberFormatter.string(from: NSNumber(value: cycleValue))
				cell.detailLabel.text = "Every \(ordinal ?? "??") day of month"
				break
			case .fixedDayOfWeek:
				cell.detailLabel.text = "Every \(Constants.namesOfDays[cycleValue])"
				break
			}
		} else {
			cell.pinImageView.isHidden = true
			cell.confirmButton.isHidden = true
			cell.detailLabel.text = ""
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

