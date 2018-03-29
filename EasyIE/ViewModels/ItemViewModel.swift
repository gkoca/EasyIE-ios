//
//  ItemViewModel.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

class ItemViewModel: NSObject {
	
	private var items = Items()
	
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
	
	func addItem(_ item:Item, success: @escaping (() -> Void)) {
		ItemDB.insert(item) {
			self.loadItems()
			success()
		}
	}
}
