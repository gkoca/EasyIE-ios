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
			var day = Day()
			for item in items {
				day = Day(day: item.date.day, month: item.date.month, year: item.date.year)
				period = Period(month: item.date.month, year: item.date.year)
				
//				if allPeriodItems[period] != nil {
//					allPeriodItems[period]?.append(item)
//				} else {
//					allPeriodItems[period] = [item]
//				}
				
				if allTimelineItems[period] != nil {
					if allTimelineItems[period]![day] != nil {
						allTimelineItems[period]![day]?.append(item)
					} else {
						allTimelineItems[period]![day] = [item]
					}
				} else {
					allTimelineItems[period] = [day: [item]]
				}
				
				
			}
//			allPeriodicItems = allPeriodicItems.sorted( by: { $0.key < $1.key } ) as [Period:Items]
//			print(allPeriodItems.map({ ($0.key.description, $0.value.count) }))
			
//			print(allTimelineItems.map({
//				($0.key.description, $0.value.count, $0.value.map({
//					($0.key.description, $0.value.count )
//				}))
//			}))
		}
	}
	
//	private var allPeriodItems = [Period:Items]()
//	private var filteredPeriodItems = [Period:Items]()
	
	private var allTimelineItems = [Period: [Day: Items]]()
	private var filteredTimelineItems = [Period: [Day: Items]]()
	
	var itemViewNeedsUpdate = false
	
	func loadDummyEntries(completion: @escaping () -> Void) {
		let path = Bundle.main.path(forResource: "MOCK_DATA_1000", ofType: "json")
		let url = URL(fileURLWithPath: path!)
		//swiftlint:disable syntactic_sugar
		if let items = try? Array<Item>(fromURL: url) {
			ItemDB.insert(items)
			self.items = items
			completion()
		}
		//swiftlint:enable syntactic_sugar
	}
	
	func loadItems() {
		items = ItemDB.getAll()
		if items.isEmpty {
			loadDummyEntries {
				print("\(self.items.count) items loaded from json")
				self.setFilteredTimelineItemsForFirst()
			}
		} else {
			setFilteredTimelineItemsForFirst()
		}
		itemViewNeedsUpdate = true
	}
	
	func addItem(_ item: Item, success: @escaping (() -> Void)) {
		ItemDB.insert(item) {
			self.loadItems()
			success()
		}
	}
}

// MARK: Timeline
extension ItemViewModel {
	
	func sortTimelineItems() {
		let allItems = allTimelineItems
		for (period, itemsOfDay) in allItems {
			let allItemsOfDay = itemsOfDay
			for (day, items) in allItemsOfDay {
				if allTimelineItems[period] != nil {
					allTimelineItems[period]![day] = items.sorted(by: { $0.date < $1.date })
				} else {
					print("⚠️ investigate allPeriodDayItems[\(period.description)]")
				}
			}
		}
	}
	
	func setFilteredTimelineItemsForFirst() {
		sortTimelineItems()
		filteredTimelineItems.removeAll()
		var allYears = allTimelineItems.map { $0.key.year }
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
		
		var allMonthsOfNearestYear = allTimelineItems.filter { $0.key.year == nearestYear }.map { $0.key.month }
		
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
		
		filteredTimelineItems[currentOrNearestPeriod] = allTimelineItems[currentOrNearestPeriod]
		
		let allPeriods = allTimelineItems.map { $0.key }.sorted(by: <)
		var nextPeriod: Period?
		var previousPeriod: Period?
		if let indexOfCurrentOrNearestPeriod = allPeriods.index(of: currentOrNearestPeriod) {
			if indexOfCurrentOrNearestPeriod < allPeriods.count - 1 {
				nextPeriod = allPeriods[indexOfCurrentOrNearestPeriod + 1]
			}
			if indexOfCurrentOrNearestPeriod > 0 {
				previousPeriod = allPeriods[indexOfCurrentOrNearestPeriod - 1]
			}
		}
		
		if let nextPeriod = nextPeriod {
			filteredTimelineItems[nextPeriod] = allTimelineItems[nextPeriod]
		}
		
		if let previousPeriod = previousPeriod {
			filteredTimelineItems[previousPeriod] = allTimelineItems[previousPeriod]
		}
	}
	
	func getKeysOfTimelineItems() -> [Period] {
		return filteredTimelineItems.map { $0.key }.sorted(by: <)
	}
	
	func getPeriod(at section: Int) -> Period {
		return getKeysOfTimelineItems()[section]
	}
	
	func getNumberOfPeriodsToDisplay() -> Int {
		return filteredTimelineItems.count
	}

	func getNumberOfItems(in period: Period) -> Int {
		return getTimelineItems(in: period).count
	}
	
	func getTimelineItems(in period: Period) -> TimelineItems {
		//		TODO: imlementation
		return TimelineItems()
	}
	
	func getTimelineItem(in period: Period, at index: Int) -> TimelineItem {
		return getTimelineItems(in: period)[index]
	}

	func canGetOnePast(of period: Period) -> Bool {
		let allKeys = allTimelineItems.map { $0.key }.sorted(by: <)
		var targetPeriod: Period?
		var isSuccess = false
		if var index = allKeys.index(of: period), index > 0 {
			index -= 1
			targetPeriod = allKeys[index]
		}
		if let thePeriod = targetPeriod {
			filteredTimelineItems[thePeriod] = allTimelineItems[thePeriod]
			isSuccess = true
		}
		return isSuccess
	}
	
}

/*
// MARK: Periodic
extension ItemViewModel {
	
	func canGetOnePast(of period: Period) -> Bool {
		let allKeys = allPeriodItems.map { $0.key }.sorted(by: <)
		var targetPeriod: Period? = nil
		var isSuccess = false
		if var index = allKeys.index(of: period), index > 0 {
			index -= 1
			targetPeriod = allKeys[index]
		}
		if let thePeriod = targetPeriod {
			filteredPeriodItems[thePeriod] = allPeriodItems[thePeriod]
			isSuccess = true
		}
		return isSuccess
	}
	
	func sortAll() {
		let allItems = allPeriodItems
		for (period, items) in allItems {
			allPeriodItems[period] = items.sorted(by: { $0.date < $1.date })
		}
	}
	
	func setFilteredPeriodicItemsForFirst() {
		sortAll()
		filteredPeriodItems.removeAll()
		var allYears = allPeriodItems.map { $0.key.year }
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

		var allMonthsOfNearestYear = allPeriodItems.filter { $0.key.year == nearestYear }.map { $0.key.month  }
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

		print("currentOrNearestPeriod : \(currentOrNearestPeriod.description)")
		print("finished first step")

		filteredPeriodItems[currentOrNearestPeriod] = allPeriodItems[currentOrNearestPeriod]

		let allPeriods = allPeriodItems.map { $0.key }.sorted(by: <)
		var nextPeriod: Period?
		var previousPeriod: Period?
		print("all sorted periods\n\(allPeriods.map({ $0.description }))")
		if let indexOfCurrentOrNearestPeriod = allPeriods.index(of: currentOrNearestPeriod) {
			if indexOfCurrentOrNearestPeriod < allPeriods.count - 1 {
				nextPeriod = allPeriods[indexOfCurrentOrNearestPeriod + 1]
			}
			if indexOfCurrentOrNearestPeriod > 0 {
				previousPeriod = allPeriods[indexOfCurrentOrNearestPeriod - 1]
			}
		}

		if let nextPeriod = nextPeriod {
			filteredPeriodItems[nextPeriod] = allPeriodItems[nextPeriod]
		}

		if let previousPeriod = previousPeriod {
			filteredPeriodItems[previousPeriod] = allPeriodItems[previousPeriod]
		}

	}
	
	func getKeysOfPeriodicItems() -> [Period] {
		return filteredPeriodItems.map { $0.key }.sorted(by: <)
	}
	
	func getItemsInPeriod(period: Period) -> Items {
		guard let items = filteredPeriodItems[period] else {
			return Items()
		}
		return items
	}
	
	func getItemsInPeriod(period: Int) -> Items {
		guard let items = filteredPeriodItems[getKeysOfPeriodicItems()[period]] else {
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
*/
