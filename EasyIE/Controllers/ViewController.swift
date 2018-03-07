//
//  ViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var entryViewModel: EntryViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		entryViewModel.loadEntries()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entryViewModel.getNumberOfEntriesToDisplay()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell
		let amount = entryViewModel.getEntryAmountAtIndex(indexPath.row)
		cell.amountLabel.text = String(amount)
		cell.amountLabel.textColor = amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
		cell.detailLabel.text = entryViewModel.getEntryDetailAtIndex(indexPath.row)
		cell.dateLabel.text = entryViewModel.getEntryDateStringAtIndex(indexPath.row)
		cell.cellImageView.image = entryViewModel.determineEntryImageAtIndex(indexPath.row)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

