//
//  TimelineItem.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 21.07.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//
//import UIKit

typealias TimelineItems = [TimelineItem]

enum TimelineItemType: Int {
//	case undefined = 0
	case dayInfo = 0
	case normal
	case fixed
//	case seperator
}

class TimelineItem {
	var type: TimelineItemType
	var item: Item?
	var dayInfo: Day?
//	var cell: UITableViewCell
	
	init(with type: TimelineItemType, item: Item? = nil, day: Day? = nil) {
		self.type = type
		self.item = item
		self.dayInfo = day
//		switch type {
//		case .undefined:
//			fatalError("Timeline item type can not be UNDEFINED")
//		case .dayInfo:
//			let theCell = DayInfoTimelineCell()
//			self.cell = theCell
//		case .normal:
//			guard let item = item else { fatalError("missing parameter") }
//			self.item = item
//			let theCell = NormalTimelineCell()
//			theCell.item = item
//			self.cell = theCell
//		case .fixed:
//			guard let item = item else { fatalError("missing parameter") }
//			self.item = item
//			let theCell = FixedTimelineCell()
//			theCell.item = item
//			self.cell = theCell
//		case .seperator:
//			let theCell = SeperatorTimelineCell()
//			self.cell = theCell
//		}
	}
}
