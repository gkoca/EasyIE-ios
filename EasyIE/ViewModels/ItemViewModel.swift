//
//  ItemViewModel.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

class ItemViewModel: NSObject {
	
	private var items = Items() {
		didSet {
			var month = 0, year = 0
			var sectionKey = ""
			var monthlyItems = Items()
			for item in items {
				if month == item.date.month && year == item.date.year {
					monthlyItems.append(item)
					keyedItems[sectionKey] = monthlyItems
				} else {
					monthlyItems = Items()
					month = item.date.month
					year = item.date.year
					monthlyItems.append(item)
					let formatter = DateFormatter()
					formatter.dateFormat = "MMMM yyyy"
					sectionKey = formatter.string(from: item.date)
					keyedItems[sectionKey] = monthlyItems
				}
			}
			print(keyedItems)
		}
	}
	private var keyedItems = [String:Items]()
	
	var itemViewNeedsUpdate = false
	
	func loadDummyEntries(completion: @escaping () -> Void) {
		let path = Bundle.main.path(forResource: "MOCK_DATA_20", ofType: "json")
		let url = URL(fileURLWithPath: path!)
		if let items = try? Array<Item>(fromURL: url) {
			ItemDB.insert(items)
			self.items = items
			completion()
		}
	}
	
	func loadItems() {
		items = ItemDB.getAll().sorted(by: { (e0, e1) -> Bool in
			e0.date < e1.date
		})
		if items.isEmpty {
			loadDummyEntries {
				print("\(self.items.count) items loaded from json")
			}
		}
		itemViewNeedsUpdate = true
	}
	
	func addItem(_ item:Item, success: @escaping (() -> Void)) {
		ItemDB.insert(item) {
			self.loadItems()
			success()
		}
	}
}

//MARK: Array
extension ItemViewModel {
	
	func getNumberOfItemsToDisplay() -> Int {
		return items.count
	}
	
	func getItemTagsAtIndex(_ index: Int) -> [Tag] {
		return items[index].tags.map({ $0 })
	}
	
	func getItemAmountAtIndex(_ index: Int) -> Double {
		return items[index].amount
	}
	
	func getItemDateStringAtIndex(_ index: Int) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: items[index].date)
	}
	
	func getItemIsFixedAtIndex(_ index: Int) -> Bool {
		return items[index].isFixed
	}
	
	func getItemCycleTypeAtIndex(_ index: Int) -> DateCycleType {
		return DateCycleType(rawValue: items[index].cycleType)!
	}
	
	func getItemCycleValueAtIndex(_ index: Int) -> Int {
		return items[index].cycleValue
	}
	
}

//MARK: Dictionary
extension ItemViewModel {
	
	func getKeysOfKeyedItems() -> [String] {
		return keyedItems.map({ $0.key })
	}
	
	func getNumberOfSectionToDisplay() -> Int {
		return keyedItems.count
	}
	
	func getNumberOfItemsInSection(section: Int) -> Int {
		return getItemsInSection(section: section).count
	}
	
	func getNumberOfItemsInSection(section: String) -> Int {
		return getItemsInSection(section: section).count
	}
	
	func getItemsInSection(section: Int) -> Items {
		guard let items = keyedItems[getKeysOfKeyedItems()[section]] else {
			return Items()
		}
		return items
	}
	
	func getItemsInSection(section: String) -> Items {
		guard let items = keyedItems[section] else {
			return Items()
		}
		return items
	}
	
	func getItemTagsAtSectionAndIndex(section: Int, index: Int) -> [Tag] {
//		return items[index].tags.map({ $0 })
		return keyedItems[getKeysOfKeyedItems()[section]]![index].tags.map({ $0 })
	}
	
	func getItemAmountAtSectionAndIndex(section: Int, index: Int) -> Double {
		return items[index].amount
	}
	
	func getItemDateStringAtSectionAndIndex(section: Int, index: Int) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMMM yyyy"
		return dateFormatter.string(from: keyedItems[getKeysOfKeyedItems()[section]]![index].date)
	}
	
	func getItemIsFixedAtSectionAndIndex(section: Int, index: Int) -> Bool {
		return keyedItems[getKeysOfKeyedItems()[section]]![index].isFixed
	}
	
	func getItemCycleTypeAtSectionAndIndex(section: Int, index: Int) -> DateCycleType {
		return DateCycleType(rawValue: keyedItems[getKeysOfKeyedItems()[section]]![index].cycleType)!
	}
	
	func getItemCycleValueAtSectionAndIndex(section: Int, index: Int) -> Int {
		return keyedItems[getKeysOfKeyedItems()[section]]![index].cycleValue
	}
}
