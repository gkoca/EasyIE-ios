//
//  AddItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Eureka
import SwifterSwift
import SearchTextField

class AddItemViewController: FormViewController {
	
	let tags = TagDB.getAllSTags()
	let daysOfWeek = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	let daysOfMonth = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
					   "11st","12nd","13rd", "14th","15th","16th","17th","18th","19th","20th",
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
						assertionFailure("selected undefined dateCycleType")
						break
					case .firstWorkDayOfMonth:
						print("firstWorkDayOfMonth")
						self.itemCycleType = .firstWorkDayOfMonth
						break
					case .lastWorkDayOfMonth:
						print("lastWorkDayOfMonth")
						self.itemCycleType = .lastWorkDayOfMonth
						break
					case .firstDayOfMonth:
						print("firstDayOfMonth")
						self.itemCycleType = .firstDayOfMonth
						break
					case .lastDayOfMonth:
						print("lastDayOfMonth")
						self.itemCycleType = .lastDayOfMonth
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
					self.itemCycleValue = self.daysOfMonth.index(of: (row.inlineRow?.value)!)! + 1
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
					self.itemCycleValue = self.daysOfWeek.index(of: (row.inlineRow?.value)!)! + 1
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
			
//			+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete]) {
//				$0.tag = "tagFields"
//				$0.addButtonProvider = { section in
//					return ButtonRow() {
//						$0.title = "Add New Tag"
//						}.cellUpdate { cell, row in
//							cell.textLabel?.textAlignment = .left
//					}
//				}
//				$0.multivaluedRowToInsertAt = { index in
//					return SuggestionAccessoryRow<STag>("SuggestionAccessoryRow_\(index)") {
//						$0.filterFunction = { [unowned self] text in
//							let filteredValue = self.tags.filter({
//								$0.value
//									.lowercased()
//									.folding(options: .diacriticInsensitive, locale: Locale.current)
//									.contains(text
//										.lowercased()
//										.folding(options: .diacriticInsensitive, locale: Locale.current))
//							})
//							if filteredValue.count > 0 {
//								return filteredValue
//							} else {
//								if text.count > 0 {
//									return [STag(value: text)]
//								} else {
//									return []
//								}
//							}
//						}
//						$0.onChange({ (suggestionAccessoryRow) in
//							print(suggestionAccessoryRow)
//						})
//						$0.placeholder = "Tag Name"
//						}.onChange({ (suggestionAccessoryRow) in
//							print(suggestionAccessoryRow)
//							if let tag = suggestionAccessoryRow.value {
//								if tag.value.isEmpty {
//									print("tag isEmpty")
//								} else {
//									print("tag isNotEmpty")
//								}
//							}
//						})
//				}
//
//		}
		
		+++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
						   header: "Multivalued TextField",
						   footer: ".Insert multivaluedOption adds the 'Add New Tag' button row as last cell.") {
							$0.tag = "textfields"
							$0.addButtonProvider = { section in
								return ButtonRow(){
									$0.title = "Add New Tag"
									}.cellUpdate { cell, row in
										cell.textLabel?.textAlignment = .left
								}
							}
//							$0.multivaluedRowToInsertAt = { index in
//								return TextRow() {
//									$0.placeholder = "Tag Name"
//									}.onChange({ (nameRow) in
//										print(nameRow.value ?? "no value")
//									}).onCellSelection({ (cell, nameRow) in
//										print("Selected : \(nameRow.value ?? "no value")")
//									})
//							}
							
							$0.multivaluedRowToInsertAt = { index in
								return AutocompleteTextRow() {
									$0.tag = "search"
									$0.filterStrings = self.tagsStrings
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
				item.cycleType = itemCycleType.rawValue
				item.cycleValue = itemCycleValue
				
				
				assertionFailure("not implemented")
			} else {
				item.date = itemDate
			}
			
			let values = form.values()
			itemTags.removeAll()
			if let stags = values["tagFields"] as? [STag], stags.count > 0 {
				
				stags.forEach({ itemTags.append($0.managedObject()) })
				
				self.item.tags.append(objectsIn: itemTags)
				
				print(itemTags)
				
			} else {
				assertionFailure("need at least one tag")
			}
			ItemDB.insert(item)
		} else {
			assertionFailure("item.amount cannot be zero")
		}
	}
	
	
	let tagsStrings = TagDB.getAllTags().flatMap { (tag) -> String? in
		tag.value
	}
	
}


