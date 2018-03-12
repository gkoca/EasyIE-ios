//
//  EntryViewModel.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import UIKit

class EntryViewModel: NSObject {
	
	private var entries = Entries()
	
	func loadDummyEntries(completion: @escaping () -> Void) {
		let path = Bundle.main.path(forResource: "MOCK_DATA_20", ofType: "json")
		let url = URL(fileURLWithPath: path!)
		if let entries = try? Array<Entry>(fromURL: url) {
							EntryDB.insert(entries)
							self.entries = entries
							completion()
		}
//		if let data = try? Data(contentsOf: url) {
//			if let entries = try? JSONDecoder().decode([Entry].self, from: data) {
//				EntryDB.insert(entries)
//				self.entries = entries
//				completion()
//			}
//		}
	}
	
	func loadEntries() {
		entries = EntryDB.getAll().sorted(by: { (e0, e1) -> Bool in
			e0.date < e1.date
		})
		if entries.isEmpty {
			loadDummyEntries {
				print("\(self.entries.count) entries loaded from json")
			}
		}
	}
	
	func getNumberOfEntriesToDisplay() -> Int {
		return entries.count
	}
	
	func getEntryTagsAtIndex(_ index: Int) -> [Tag] {
		return entries[index].tags.map({ $0 })
	}
	
	func getEntryAmountAtIndex(_ index: Int) -> Double {
		return entries[index].amount
	}
	
	func getEntryDateStringAtIndex(_ index: Int) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: entries[index].date)
	}
	
}
