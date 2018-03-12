//
//  EntryViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var entryViewModel: EntryViewModel!
	
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
		tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension EntryViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entryViewModel.getNumberOfEntriesToDisplay()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell
		let amount = entryViewModel.getEntryAmountAtIndex(indexPath.row)
		cell.amountLabel.text = amount > 0 ? "+" + String(amount) : String(amount)
		cell.amountLabel.textColor = amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
//		cell.detailLabel.text = entryViewModel.getEntryDetailAtIndex(indexPath.row)
		var tags = ""
		for tag in entryViewModel.getEntryTagsAtIndex(indexPath.row) {
			tags += tag.value
			tags += " | "
		}
		tags.removeLast(3)
		cell.detailLabel.text = tags
		cell.dateLabel.text = entryViewModel.getEntryDateStringAtIndex(indexPath.row)
//		cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

