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
			}
//			allPeriodicItems = allPeriodicItems.sorted( by: { $0.key < $1.key } ) as [Period:Items]
			print(allPeriodicItems.map({ $0.key.localizedDescription }))
		}
	}
	
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
		items = ItemDB.getAll()
		if items.isEmpty {
			loadDummyEntries {
				print("\(self.items.count) items loaded from json")
				self.setFilteredPeriodicItemsForFirst()
			}
		} else {
			setFilteredPeriodicItemsForFirst()
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

//Mark Periodic
extension ItemViewModel {
	
	func canGetOnePast(of period: Period) -> Bool {
		let allKeys = allPeriodicItems.map { $0.key }.sorted(by: <)
		var targetPeriod: Period? = nil
		var isSuccess = false
		if var index = allKeys.index(of: period), index > 0 {
			index -= 1
			targetPeriod = allKeys[index]
		}
		if let thePeriod = targetPeriod {
			filteredPeriodicItems[thePeriod] = allPeriodicItems[thePeriod]
			isSuccess = true
		}
		return isSuccess
	}
	
	func sortAll() {
		let allItems = allPeriodicItems
		for (period, items) in allItems {
			allPeriodicItems[period] = items.sorted(by: { $0.date < $1.date })
		}
	}
	
	func setFilteredPeriodicItemsForFirst() {
		sortAll()
		filteredPeriodicItems.removeAll()
		var allYears = allPeriodicItems.map { $0.key.year }
		allYears.removeDuplicates()
		var currentOrNearestPeriod = Period()
		let currentYear = Date().year
		let currentMonth = Date().month
		var nearestYear = allYears[0]
		if allYears.count > 1 {
			var distanceOfYear = abs(allYears[0] - currentYear)
			var indexOfYear = 0
			for i in 1...allYears.count - 1 {
				let differenceOfYear = abs(allYears[i] - currentYear)
				if differenceOfYear < distanceOfYear {
					indexOfYear = i
					distanceOfYear = differenceOfYear
				}
			}
			nearestYear = allYears[indexOfYear] //nearest year found
		}
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
		
		let allPeriods = allPeriodicItems.map { $0.key }.sorted(by: <)
		var nextPeriod: Period?
		var previousPeriod: Period?
		print("all sorted periods\n\(allPeriods.map({ $0.localizedDescription }))")
		if let indexOfCurrentOrNearestPeriod = allPeriods.index(of: currentOrNearestPeriod) {
			if indexOfCurrentOrNearestPeriod < allPeriods.count - 1 {
				nextPeriod = allPeriods[indexOfCurrentOrNearestPeriod + 1]
			}
			if indexOfCurrentOrNearestPeriod > 0 {
				previousPeriod = allPeriods[indexOfCurrentOrNearestPeriod - 1]
			}
		}
		
		if let nextPeriod = nextPeriod {
			filteredPeriodicItems[nextPeriod] = allPeriodicItems[nextPeriod]
		}
		
		if let previousPeriod = previousPeriod {
			filteredPeriodicItems[previousPeriod] = allPeriodicItems[previousPeriod]
		}
		
	}
	
	func getKeysOfPeriodicItems() -> [Period] {
		return filteredPeriodicItems.map { $0.key }.sorted(by: <)
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
	
	func getItemAtPeriodAndIndex(period: Period, index: Int) -> Item {
		return getItemsInPeriod(period: period)[index]
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
