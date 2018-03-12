//
//  ItemViewModel.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import UIKit

class ItemViewModel: NSObject {
	
	private var items = Items()
	
	func loadDummyEntries(completion: @escaping () -> Void) {
		let path = Bundle.main.path(forResource: "MOCK_DATA_20", ofType: "json")
		let url = URL(fileURLWithPath: path!)
		if let items = try? Array<Item>(fromURL: url) {
							ItemDB.insert(items)
							self.items = items
							completion()
		}
//		if let data = try? Data(contentsOf: url) {
//			if let items = try? JSONDecoder().decode([Item].self, from: data) {
//				ItemDB.insert(items)
//				self.items = items
//				completion()
//			}
//		}
	}
	
	func loadEntries() {
		items = ItemDB.getAll().sorted(by: { (e0, e1) -> Bool in
			e0.date < e1.date
		})
		if items.isEmpty {
			loadDummyEntries {
				print("\(self.items.count) items loaded from json")
			}
		}
	}
	
	func getNumberOfEntriesToDisplay() -> Int {
		return items.count
	}
	
	func getEntryTagsAtIndex(_ index: Int) -> [Tag] {
		return items[index].tags.map({ $0 })
	}
	
	func getEntryAmountAtIndex(_ index: Int) -> Double {
		return items[index].amount
	}
	
	func getEntryDateStringAtIndex(_ index: Int) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: items[index].date)
	}
	
	func getEntryIsFixedAtIndex(_ index: Int) -> Bool {
		return items[index].isFixed
	}
	
	func getEntryCycleTypeAtIndex(_ index: Int) -> DateCycleType {
		return DateCycleType(rawValue: items[index].cycleType)!
	}
}
