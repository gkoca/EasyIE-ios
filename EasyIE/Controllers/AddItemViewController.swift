//
//  AddItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Eureka
import SwifterSwift

class AddItemViewController: FormViewController, UITextFieldDelegate {
	
	@IBOutlet var tagViewModel: TagViewModel!
	var parentVC: UIViewController?
	
	let daysOfWeek = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	let daysOfMonth = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
					   "11th","12th","13th", "14th","15th","16th","17th","18th","19th","20th",
					   "21st","22nd","23rd","24th","25th", "26th","27th","28th","29th","30th",
					   "31st"]
	
	let cycleTypes = ["First Day Of Month", "Last Day Of Month",
					  "First Work Day Of Month", "Last Work Day Of Month",
					  "Day of month", "Day of week" ]
	
	var item = Item()
	var itemIsIncome = true
	var itemIsFixed = false
	var itemAmount = 0.0
	var itemCycleType = DateCycleType.undefined
	var itemCycleValue = 0
	var itemDate = Date()
	var itemTags = [Tag]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tagViewModel.loadTags()
		form +++ Section()
			<<< SegmentedRow<String>("itemType") {
				$0.title = ""
				$0.value = "Income"
				$0.options = ["Income", "Expense"]
				
				}.cellSetup({ (cell, _) in
					cell.segmentedControl.tintColor = UIColor.AppColor.colorIncome
				}).onChange({ (segmentedRow) in
					switch segmentedRow.value {
					case segmentedRow.options![0]?:
						segmentedRow.cell.segmentedControl.tintColor = UIColor.AppColor.colorIncome
						self.itemIsIncome = true
						break
					case segmentedRow.options![1]?:
						segmentedRow.cell.segmentedControl.tintColor = UIColor.AppColor.colorExpense
						self.itemIsIncome = false
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
					self.itemIsFixed = switchRow.value!
				})
			
			+++ Section(footer: "Choose your date cycle your fixed entry.") {
				$0.hidden = .function(["isFixed"], { form -> Bool in
					let row: RowOf<Bool>! = form.rowBy(tag: "isFixed")
					return row.value ?? false == false
				})
			}
			<<< PickerInlineRow<String>("cycleType") {
				$0.title = "Date cycle type"
				$0.options = cycleTypes
				$0.value = cycleTypes.first ?? ""
				}.onChange({ (row) in
					let indexOfCycleType = self.cycleTypes.index(of: (row.inlineRow?.value!)!)!
					let dateCycleType: DateCycleType = DateCycleType(rawValue: indexOfCycleType + 1)!
					switch dateCycleType {
					case .undefined:
						fatalError("selected undefined dateCycleType")
						break
					case .firstWorkDayOfMonth:
						print("firstWorkDayOfMonth")
						self.itemCycleType = .firstWorkDayOfMonth
						self.itemCycleValue = 0
						break
					case .lastWorkDayOfMonth:
						print("lastWorkDayOfMonth")
						self.itemCycleType = .lastWorkDayOfMonth
						self.itemCycleValue = 0
						break
					case .firstDayOfMonth:
						print("firstDayOfMonth")
						self.itemCycleType = .firstDayOfMonth
						self.itemCycleValue = 0
						break
					case .lastDayOfMonth:
						print("lastDayOfMonth")
						self.itemCycleType = .lastDayOfMonth
						self.itemCycleValue = 0
						break
					case .fixedDayOfMonth:
						print("fixedDayOfMonth")
						self.itemCycleType = .fixedDayOfMonth
						break
					case .fixedDayOfWeek:
						print("fixedDayOfWeek")
						self.itemCycleType = .fixedDayOfWeek
						break
					}
				})
			
			<<< PickerInlineRow<String>("daysOfMonth") {
				$0.title = "Every"
				$0.options = daysOfMonth
				$0.value = "\(daysOfMonth.first!) day of month"
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Day of month" ? false : true
				})
				}.onChange({ (row) in
					row.value = "\(row.inlineRow?.value ?? "1st") day of month"
					print("itemCycleValue : \(self.daysOfMonth.index(of: (row.inlineRow?.value)!)! + 1)")
					self.itemCycleValue = (DaysOFMonth(rawValue: (row.inlineRow?.indexPath?.row)!)?.rawValue)!
					//					self.itemCycleValue = self.daysOfMonth.index(of: (row.inlineRow?.value)!)! + 1
				})
			
			<<< PickerInlineRow<String>("daysOfWeek") {
				$0.title = "Every"
				$0.options = daysOfWeek
				$0.value = daysOfWeek.first
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Day of week" ? false : true
				})
				}.onChange({ (row) in
					print("itemCycleValue : \(self.daysOfWeek.index(of: (row.inlineRow?.value)!)! + 1)")
					self.itemCycleValue = (DaysOfWeek(rawValue: (row.inlineRow?.indexPath?.row)!)?.rawValue)!
				})
			
			+++ Section()
			<<< DateInlineRow("Date") {
				$0.title = $0.tag
				$0.value = Date()
				$0.hidden = .function(["isFixed"], { form -> Bool in
					let row: RowOf<Bool>! = form.rowBy(tag: "isFixed")
					return row.value ?? true == true
				})
				}.onChange({ (row) in
					self.itemDate = row.inlineRow?.value ?? Date()
				})
			
			+++ Section()
			<<< DecimalRow("Amount"){
				$0.title = $0.tag
				$0.placeholder = "0.00 ₺"
				}.onChange({ (row) in
					if let rowValue = row.value, rowValue > 0 {
						self.itemAmount = rowValue
					}
				})
			
			
			+++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
				$0.tag = "tagFields"
				$0.addButtonProvider = { section in
					return ButtonRow(){
						$0.title = "Add New Tag"
						$0.tag = "addNewTagButton"
						}.cellUpdate { cell, row in
							cell.textLabel?.textAlignment = .left
					}
				}
				
				$0.multivaluedRowToInsertAt = { index in
					return AutocompleteTextRow() {
						$0.placeholder = "Tag Name"
						$0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .next, defaultKeyboardType: .done)
						$0.filterStrings = self.tagViewModel.getAllTagsAsStringArray()
						$0.inlineMode = true
					}
				}
		}
		rowKeyboardSpacing = 50.0
	}
	
	@IBAction func onCancelButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onDoneButton(_ sender: Any) {
		validate(form)
	}
	
	func validate(_ form: Form) {
		if itemAmount > 0 {
			if itemIsIncome {
				item.amount = itemAmount
			} else {
				item.amount = -itemAmount
			}
			if itemIsFixed {
				item.isFixed = itemIsFixed
				item.cycleType = itemCycleType.rawValue
				switch itemCycleType {
				case .undefined:
					assertionFailure("selected undefined dateCycleType")
				case .firstDayOfMonth:
					if itemCycleValue > 0 {
						assertionFailure("wrong value for firstDayOfMonth")
					}
				case .lastDayOfMonth:
					if itemCycleValue > 0 {
						assertionFailure("wrong value for lastDayOfMonth")
					}
				case .firstWorkDayOfMonth:
					if itemCycleValue > 0 {
						assertionFailure("wrong value for firstWorkDayOfMonth")
					}
				case .lastWorkDayOfMonth:
					if itemCycleValue > 0 {
						assertionFailure("wrong value for lastWorkDayOfMonth")
					}
				case .fixedDayOfMonth:
					if itemCycleValue > 0 {
						item.cycleValue = itemCycleValue
					} else {
						assertionFailure("wrong value for fixedDayOfMonth")
					}
				case .fixedDayOfWeek:
					if itemCycleValue > 0 {
						item.cycleValue = itemCycleValue
					} else {
						assertionFailure("wrong value for fixedDayOfWeek")
					}
				}
			} else {
				item.date = itemDate
			}
			let values = form.values()
			itemTags.removeAll()
			if let tags = values["tagFields"] as? [String], tags.count > 0 {
				for tag in tags {
					if tag.count > 0 {
						itemTags.append(Tag(value: tag))
					}
				}
				if itemTags.count > 0 {
					self.item.tags.append(objectsIn: itemTags)
					if let parent = self.parentVC as? ItemViewController {
						parent.itemViewModel.addItem(item, success: {
							self.dismiss(animated: true, completion: nil)
						})
					}
				} else {
					emptyTagAlert(form)
				}
			} else {
				emptyTagAlert(form)
			}
		} else {
			let amountType = itemIsIncome ? "income" : "expense"
			GlobalAlertController.showSingleActionAlert(title: "Amount is \"0\".", message: "Please enter amount of your \(amountType).")
		}
	}
	
	func emptyTagAlert(_ form: Form) {
		GlobalAlertController.showSingleActionAlert(title: "There is no tag.", message: "Please enter at least one tag.")
	}
}




