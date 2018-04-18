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
			//TODO: Remove
			var month = 0, year = 0
			var sectionKey = ""
			var monthlyItems = Items()
			
			var period = Period()
			var periodicItems = Items()
			
			for item in items {
				if period == Period(month: item.date.month, year: item.date.year) {
					periodicItems.append(item)
					allPeriodicItems[period] = periodicItems
				} else {
					periodicItems = Items()
					period = Period(month: item.date.month, year: item.date.year)
					periodicItems.append(item)
					allPeriodicItems[period] = periodicItems
				}
				
				//TODO: Remove
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
//			allPeriodicItems = allPeriodicItems.sorted( by: { $0.key < $1.key } ) as [Period:Items]
			print(allPeriodicItems.map({ $0.key.localizedDescription }))
		}
	}
	private var keyedItems = [String:Items]()
	private var keyedFilteredItems = [String:Items]()
	
	private var allPeriodicItems = [Period:Items]()
	private var filteredPeriodicItems = [Period:Items]()
	
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
		setFilteredPeriodicItemsForFirst()
//		filteredPeriodicItems = allPeriodicItems
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

//Mark Periodic
extension ItemViewModel {
	
	func setFilteredPeriodicItemsForFirst() {
		filteredPeriodicItems.removeAll()
		var allYears = allPeriodicItems.map { $0.key.year }
		allYears.removeDuplicates()
		var currentOrNearestPeriod = Period()
		let currentYear = Date().year
		let currentMonth = Date().month
		
		var distanceOfYear = abs(allYears[0] - currentYear)
		var indexOfYear = 0
		for i in 1...allYears.count - 1 {
			let differenceOfYear = abs(allYears[i] - currentYear)
			if differenceOfYear < distanceOfYear {
				indexOfYear = i
				distanceOfYear = differenceOfYear
			}
		}
		let nearestYear = allYears[indexOfYear] //nearest year found
		currentOrNearestPeriod.year = nearestYear
		
		var allMonthsOfNearestYear = allPeriodicItems.filter { $0.key.year == nearestYear }.map { $0.key.month  }
		var distanceOfMonth = abs(allMonthsOfNearestYear[0] - currentMonth)
		var indexOfMonth = 0
		for i in 1...allMonthsOfNearestYear.count - 1 {
			let differenceOfMonth = abs(allMonthsOfNearestYear[i] - currentMonth)
			if differenceOfMonth < distanceOfMonth {
				indexOfMonth = i
				distanceOfMonth = differenceOfMonth
			}
		}
		let nearestMonth = allMonthsOfNearestYear[indexOfMonth]
		currentOrNearestPeriod.month = nearestMonth
		
		print("currentOrNearestPeriod : \(currentOrNearestPeriod.localizedDescription)")
		print("finished first step")
		
		filteredPeriodicItems[currentOrNearestPeriod] = allPeriodicItems[currentOrNearestPeriod]
		
	}
	
	func getKeysOfPeriodicItems() -> [Period] {
		return filteredPeriodicItems.map { $0.key }
	}
	
	func getPeriodAtSection(section: Int) -> Period {
		return getKeysOfPeriodicItems()[section]
	}
	
	func getNumberOfPeriodsToDisplay() -> Int {
		return filteredPeriodicItems.count
	}
	
	func getNumberOfItemsInPeriod(period: Period) -> Int {
		return getItemsInPeriod(period: period).count
	}
	
	func getItemsInPeriod(period: Period) -> Items {
		guard let items = filteredPeriodicItems[period] else {
			return Items()
		}
		return items
	}
	
	func getItemsInPeriod(period: Int) -> Items {
		guard let items = filteredPeriodicItems[getKeysOfPeriodicItems()[period]] else {
			return Items()
		}
		return items
	}
	
	func getItemAmountAtPeriodAndIndex(period: Period, index: Int) -> Double {
		return getItemsInPeriod(period: period)[index].amount
	}
	
	func getItemTagsAtPeriodAndIndex(period: Period, index: Int) -> [Tag] {
		return getItemsInPeriod(period: period)[index].tags.map { $0 }
	}
	
	func getItemDateStringAtPeriodAndIndex(period: Period, index: Int) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMMM yyyy"
		return dateFormatter.string(from: getItemsInPeriod(period: period)[index].date)
	}
	
	func getItemIsFixedAtPeriodAndIndex(period: Period, index: Int) -> Bool {
		return getItemsInPeriod(period: period)[index].isFixed
	}
	
	func getItemCycleTypeAtPeriodAndIndex(period: Period, index: Int) -> DateCycleType {
		return DateCycleType(rawValue: getItemsInPeriod(period: period)[index].cycleType)!
	}
	
	func getItemCycleValueAtPeriodAndIndex(period: Period, index: Int) -> Int {
		return getItemsInPeriod(period: period)[index].cycleValue
	}
	
}
