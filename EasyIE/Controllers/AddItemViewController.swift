//
//  AddItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Eureka

class AddItemViewController: FormViewController {
	
	let tags = TagDB.getAllSTags()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		form
			+++ Section()
			<<< SegmentedRow<String>("Segments") {
				$0.title = ""
				$0.value = "Income"
				$0.options = ["Income", "Expense"]
				
				}.cellSetup({ (cell, _) in
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
			<<< SwitchRow("isFixed") {
				$0.title = "Is Item Fixed"
				$0.value = false
				}.onChange({ (switchRow) in
					print("switch : \(switchRow.value ?? false)")
				})
			
			
			+++ Section(footer: "Choose your date cycle your fixed entry.") {
				$0.hidden = .function(["isFixed"], { form -> Bool in
					let row: RowOf<Bool>! = form.rowBy(tag: "isFixed")
					return row.value ?? false == false
				})
			}
			<<< PickerInlineRow<String>("cycleType") {
				$0.title = "Date cycle type"
				$0.options = ["First Work Day Of Month", "Last Work Day Of Month", "First Day Of Month", "Last Day Of Month","Day of week", "Fixed"]
				$0.value = "Fixed"
			}
			<<< DateInlineRow("cycleDate") {
				$0.title = "Date"
				$0.value = Date()
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Fixed" ? false : true
				})
			}
			<<< PickerInlineRow<String>("daysOfWeek") {
				$0.title = "Every"
				$0.options = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
				$0.value = "Monday"
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Day of week" ? false : true
				})
			}
			+++ Section()
			<<< DecimalRow(){
				$0.title = "Amount"
				$0.placeholder = "0.00 ₺"
			}
			
			+++ Section()
			<<< DateInlineRow() {
				$0.title = "Date"
				$0.value = Date()
				$0.hidden = .function(["isFixed"], { form -> Bool in
					let row: RowOf<Bool>! = form.rowBy(tag: "isFixed")
					return row.value ?? true == true
				})
			}

			+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
								   header: "TAGS") {
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
