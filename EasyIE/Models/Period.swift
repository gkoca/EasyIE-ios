//
//  Period.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 14.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

typealias Year = Int
typealias Month = Int

struct Period: Hashable, Comparable {

	var month: Year = 0
	var year: Month = 0
	var description: String {
		get {
			var date = Date()
			date.hour = 12
			date.month = month == 0 ? 1 : month
			date.year = year < 2000 ? 2000 : year
			return date.string(withFormat: "MMMM yyyy")
		}
	}

	var hashValue: Int {
		return description.hashValue
	}

	static func == (lhs: Period, rhs: Period) -> Bool {
		return lhs.month == rhs.month && lhs.year == rhs.year
	}

	static func < (lhs: Period, rhs: Period) -> Bool {
		if lhs.year == rhs.year {
			return lhs.month < rhs.month
		} else {
			return lhs.year < rhs.year
		}
	}

	static func > (lhs: Period, rhs: Period) -> Bool {
		if lhs.year == rhs.year {
			return lhs.month > rhs.month
		} else {
			return lhs.year > rhs.year
		}
	}

	static func <= (lhs: Period, rhs: Period) -> Bool {
		if lhs == rhs {
			return true
		} else {
			return lhs < rhs
		}
	}

	static func >= (lhs: Period, rhs: Period) -> Bool {
		if lhs == rhs {
			return true
		} else {
			return lhs > rhs
		}
	}
}
