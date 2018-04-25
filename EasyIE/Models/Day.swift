//
//  Day.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 25.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

#if canImport(Foundation)
import Foundation


struct Day: Hashable, Comparable {
	
	var day: Int = 0
	var month: Int = 0
	var year: Int = 0
	
	var localizedDescription: String {
		get {
			var date = Date()
			date.hour = 12
			date.day = day == 0 ? 1 : day
			date.month = month == 0 ? 1 : month
			date.year = year < 2000 ? 2000 : year
			return date.string(withFormat: "EEEE, MMM d")
		}
	}
	
	var hashValue: Int {
		return localizedDescription.hashValue
	}
	
	static func == (lhs: Day, rhs: Day) -> Bool {
		return lhs.month == rhs.month && lhs.year == rhs.year && lhs.day == rhs.day
	}
	
	static func < (lhs: Day, rhs: Day) -> Bool {
		if lhs.year == rhs.year {
			if lhs.month == rhs.month {
				return lhs.day < rhs.day
			} else {
				return lhs.month < rhs.month
			}
		} else {
			return lhs.year < rhs.year
		}
	}
	
	static func > (lhs: Day, rhs: Day) -> Bool {
		if lhs.year == rhs.year {
			if lhs.month == rhs.month {
				return lhs.day > rhs.day
			} else {
				return lhs.month > rhs.month
			}
		} else {
			return lhs.year > rhs.year
		}
	}
	
	static func <= (lhs: Day, rhs: Day) -> Bool {
		if lhs == rhs {
			return true
		} else {
			return lhs < rhs
		}
	}
	
	static func >= (lhs: Day, rhs: Day) -> Bool {
		if lhs == rhs {
			return true
		} else {
			return lhs > rhs
		}
	}
}
#endif
