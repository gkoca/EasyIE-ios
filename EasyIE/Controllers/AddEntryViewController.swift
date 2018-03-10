//
//  AddEntryViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Eureka

class AddEntryViewController: FormViewController {
	let dummyTags = [EntryTag(id: 0, value: "maaş"),EntryTag(id: 1, value: "iphone"),EntryTag(id: 2, value: "ipad"),EntryTag(id: 3, value: "macbook")]
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
//		let dummyTags = [EntryTag(id: 0, value: "maaş"),EntryTag(id: 1, value: "iphone"),EntryTag(id: 2, value: "ipad"),EntryTag(id: 3, value: "macbook")]
		
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
										return SuggestionTableRow<EntryTag>  {
											$0.filterFunction = { [unowned self] text in
												self.dummyTags.filter({ $0.value.lowercased().contains(text.lowercased()) })
											}
											$0.placeholder = "Tag Name"
										}
									}
//									$0 <<< TextRow() {
//										$0.placeholder = "Tag Name"
//									}
		}
		
		//			+++ Section("Detail")
		//			<<< TextAreaRow() {
		//				$0.placeholder = "TextAreaRow"
		//				$0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
		//		}
		
	}
	
	@IBAction func onCancelButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
