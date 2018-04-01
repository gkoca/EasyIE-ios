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
	
	let daysOfMonth = 1...31
	//TODO: Localization
	let cycleTypes = ["First Day Of Month", "Last Day Of Month",
					  "First Work Day Of Month", "Last Work Day Of Month",
					  "Day of month", "Day of week" ]
	let namesOfDays = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	
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
				//TODO: Localization
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
				//TODO: Localization
				$0.title = "Is Item Fixed"
				$0.value = false
				}.onChange({ (switchRow) in
					self.itemIsFixed = switchRow.value!
				})
			//TODO: Localization
			+++ Section(footer: "Choose your date cycle your fixed entry.") {
				$0.hidden = .function(["isFixed"], { form -> Bool in
					let row: RowOf<Bool>! = form.rowBy(tag: "isFixed")
					return row.value ?? false == false
				})
			}
			<<< PickerInlineRow<String>("cycleType") {
				//TODO: Localization
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
				//TODO: Localization
				$0.title = "Every"
				$0.options = daysOfMonth.map({
					let numberFormatter = NumberFormatter()
					numberFormatter.numberStyle = .ordinal
					//					numberFormatter.locale = Locale(identifier: "TR")
					return numberFormatter.string(from: NSNumber(value: $0)) ?? "??"
				})
				$0.value = "\($0.options.first!) day of month"
				self.itemCycleValue = 1
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Day of month" ? false : true
				})
				}.onChange({ (row) in
					row.value = "\(row.inlineRow?.value ?? "1st") day of month"
					if let inlineValue = row.inlineRow?.value {
						if let index = row.options.index(of: inlineValue) {
							self.itemCycleValue = index + 1
						} else {
							Debug.printInvestigate(#file, #line)
						}
					} else {
						Debug.printInvestigate(#file, #line)
					}
				})
			
			<<< PickerInlineRow<String>("daysOfWeek") {
				//TODO: Localization
				$0.title = "Every"
				$0.options = namesOfDays
				$0.value =  $0.options.first
				$0.hidden = .function(["cycleType"], { form -> Bool in
					let row: RowOf<String>! = form.rowBy(tag: "cycleType")
					return row.value == "Day of week" ? false : true
				})
				}.onChange({ (row) in
					//					print("itemCycleValue : \(self.daysOfWeek.index(of: (row.inlineRow?.value)!)! + 1)")
					if let inlineRow = row.inlineRow {
						if let inlineValue = inlineRow.value {
							if let index = self.namesOfDays.index(of: inlineValue) {
								self.itemCycleValue = index + 1
							} else {
								Debug.printInvestigate(#file, #line)
							}
						} else {
							Debug.printInvestigate(#file, #line)
						}
					} else {
						Debug.printInvestigate(#file, #line)
					}
				})
			
			+++ Section()
			//TODO: Localization
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
			//TODO: Localization
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
						//TODO: Localization
						$0.title = "Add New Tag"
						$0.tag = "addNewTagButton"
						}.cellUpdate { cell, row in
							cell.textLabel?.textAlignment = .left
					}
				}
				
				$0.multivaluedRowToInsertAt = { index in
					return AutocompleteTextRow() {
						//TODO: Localization
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
					Debug.printWrong(#file, #line)
				case .firstDayOfMonth:
					break
				case .lastDayOfMonth:
					break
				case .firstWorkDayOfMonth:
					break
				case .lastWorkDayOfMonth:
					break
				case .fixedDayOfMonth:
					item.cycleValue = itemCycleValue
					break
				case .fixedDayOfWeek:
					item.cycleValue = itemCycleValue
					break
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
			//TODO: Localization
			let amountType = itemIsIncome ? "income" : "expense"
			GlobalAlertController.showSingleActionAlert(title: "Amount is \"0\".", message: "Please enter amount of your \(amountType).")
		}
	}
	
	func emptyTagAlert(_ form: Form) {
		//TODO: Localization
		GlobalAlertController.showSingleActionAlert(title: "There is no tag.", message: "Please enter at least one tag.")
	}
}




