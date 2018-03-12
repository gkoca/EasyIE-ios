//
//  AddEntryViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Eureka

class AddEntryViewController: FormViewController {
	
	let tags = TagDB.getAllSTags()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		form +++ Section("Entry Type")
			<<< SegmentedRow<String>("Segments") { $0.title = ""; $0.value = "Income"; $0.options = ["Income", "Expense"]}.cellSetup({ (cell, _) in
				cell.segmentedControl.tintColor = UIColor.AppColor.colorIncome
			}).onChange({ (segmentedRow) in
				switch segmentedRow.value {
				case segmentedRow.options![0]?:
					segmentedRow.cell.segmentedControl.tintColor = UIColor.AppColor.colorIncome
					break
				case segmentedRow.options![1]?:
					segmentedRow.cell.segmentedControl.tintColor = UIColor.AppColor.colorExpense
					break
				default:
					print("shomething wrong")
					break
				}
			})
			
			+++ Section()
			<<< DecimalRow(){
				$0.title = "Amount"
				$0.placeholder = "0.00 ₺"
			}
			
			+++ Section()
			<<< DateInlineRow() {
				$0.title = "Date"
				$0.value = Date()
			}
			
			
			//item.title.folding(options: .diacriticInsensitive, locale: Locale.current).contains(searchStr.uppercased())
			+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
								   header: "TAGS",
								   footer: ".Insert multivaluedOption adds the 'Add New Tag' button row as last cell.") {
									$0.tag = "textfields"
									$0.addButtonProvider = { section in
										return ButtonRow(){
											$0.title = "Add New Tag"
											}.cellUpdate { cell, row in
												cell.textLabel?.textAlignment = .left
										}
									}
									$0.multivaluedRowToInsertAt = { index in
										return SuggestionAccessoryRow<STag>  {
											$0.filterFunction = { [unowned self] text in
												self.tags.filter({ $0.value.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current).contains(text.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current)) })
											}
											$0.placeholder = "Tag Name"
										}
									}
		}
		
		rowKeyboardSpacing = 50.0
		
	}
	
	@IBAction func onCancelButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
