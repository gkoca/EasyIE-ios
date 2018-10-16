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
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 90.0
		registerCells()
		itemViewModel.loadItems()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(anItemDidUpdate(_:)), name: .didVerifiedItem, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if itemViewModel.getNumberOfPeriodsToDisplay() > 0 && itemViewModel.itemViewNeedsUpdate {
			tableView.reloadData()
			if let lastPeriod = itemViewModel.getKeysOfTimelineItems().last {
				let indexPath = IndexPath(row: itemViewModel.getNumberOfItems(in: lastPeriod) - 1, section: itemViewModel.getNumberOfPeriodsToDisplay() - 1)
				Dispatch.main {
//					self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
			let periods = self.itemViewModel.getKeysOfTimelineItems()
			if periods.count > 0 {
				let currentFirst = self.itemViewModel.getKeysOfTimelineItems()[0]
				if self.itemViewModel.canGetOnePast(of: currentFirst) {
					self.tableView.reloadData()
				}
			}
			sender.endRefreshing()
		}
	}
	
	@objc func anItemDidUpdate(_ notification: Notification) {
		tableView.reloadData()
	}
}

extension ItemViewController {
	
	private func registerCells() {
		let fixedTimelineCellNib = UINib(nibName: "FixedTimelineCell", bundle: nil)
		let normalTimelineCellNib = UINib(nibName: "NormalTimelineCell", bundle: nil)
		let dayInfoTimelineCellNib = UINib(nibName: "DayInfoTimelineCell", bundle: nil)
		let headerTimelineCellNib = UINib(nibName: "HeaderTimelineCell", bundle: nil)
		
		tableView.register(fixedTimelineCellNib, forCellReuseIdentifier: "fixedItemTimeLineCell")
		tableView.register(normalTimelineCellNib, forCellReuseIdentifier: "normalTimelineCell")
		tableView.register(dayInfoTimelineCellNib, forCellReuseIdentifier: "dayInfoTimelineCell")
		tableView.register(headerTimelineCellNib, forCellReuseIdentifier: "headerTimelineCell")
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return itemViewModel.getNumberOfPeriodsToDisplay()
	}
	
//	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return itemViewModel.getKeysOfTimelineItems()[section].description
//	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let period = itemViewModel.getPeriod(at: section)
		return itemViewModel.getNumberOfItems(in: period)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let period = itemViewModel.getPeriod(at: indexPath.section)
		let index = indexPath.row
		let timelineCellItem = itemViewModel.getTimelineItem(in: period, at: index)
		
		switch timelineCellItem.type {
		case .dayInfo:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayInfoTimelineCell") as? DayInfoTimelineCell else {
				fatalError("dequeueReusableCell as DayInfoTimelineCell is nil")
			}
			cell.dayInfo = timelineCellItem.dayInfo
			cell.isFirstCell = timelineCellItem.isFirst
			return cell
		case .normal:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "normalTimelineCell") as? NormalTimelineCell else {
				fatalError("dequeueReusableCell as NormalTimelineCell is nil")
			}
			cell.item = timelineCellItem.item
			cell.isLastCell = timelineCellItem.isLast
			return cell
		case .fixed:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "fixedItemTimeLineCell") as? FixedTimelineCell else {
				fatalError("dequeueReusableCell as FixedTimelineCell is nil")
			}
			cell.item = timelineCellItem.item
			cell.isLastCell = timelineCellItem.isLast
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "headerTimelineCell") as? HeaderTimelineCell {
			cell.title.text = itemViewModel.getKeysOfTimelineItems()[section].description
			return cell
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

