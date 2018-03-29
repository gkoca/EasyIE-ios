//
//  Item.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Realm
import RealmSwift

typealias Items = [Item]

/*
["First Day Of Month",
"Last Day Of Month",
"First Work Day Of Month",
"Last Work Day Of Month",
"Day of month",
"Day of week" ]

["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
"11st","12nd","13rd", "14th","15th","16th","17th","18th","19th","20th",
"21st","22nd","23rd","24th","25th", "26th","27th","28th","29th","30th",
"31st"]
*/

enum DateCycleType: Int {
	case undefined = 0
	case firstDayOfMonth
	case lastDayOfMonth
	case firstWorkDayOfMonth
	case lastWorkDayOfMonth
	case fixedDayOfMonth
	case fixedDayOfWeek
}

enum DaysOfWeek: Int {
	case undefined = 0
	case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

enum DaysOFMonth: Int {
	case undefined = 0
	case _1st,  _2nd,  _3rd,  _4th,  _5th,  _6th,  _7th,  _8th,  _9th,  _10th
	case _11th, _12th, _13th, _14th, _15th, _16th, _17th, _18th, _19th, _20th
	case _21st, _22nd, _23rd, _24th, _25th, _26th, _27th, _28th, _29th, _30th, _31st
}

class Item: Object, Codable {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var amount: Double = 0.0
	@objc dynamic var isFixed: Bool = false
	@objc dynamic var cycleType: Int = 0
	@objc dynamic var cycleValue: Int = 0
	@objc dynamic var date: Date = Date()
	
	var tags = List<Tag>()
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case amount = "amount"
		case date = "date"
		case isFixed = "isFixed"
		case cycleType = "cycleType"
		case cycleValue = "cycleValue"
		case tags = "tags"
	}
	
	init(id: String = UUID().uuidString,
		 amount: Double = 0.0,
		 date: Date = Date(),
		 isFixed: Bool = false,
		 cycleType: Int = DateCycleType.undefined.rawValue,
		 cycleValue: Int = 0,
		 tags: List<Tag> = List<Tag>()) {
		super.init()
		self.id = id
		self.amount = amount
		self.date = date
		self.isFixed = isFixed
		self.cycleType = cycleType
		self.cycleValue = cycleValue
		self.tags = tags
		
	}
	
	required init() {
		super.init()
	}
	
	required convenience init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let id = try container.decode(String.self, forKey: .id)
		let amount = try container.decode(Double.self, forKey: .amount)
		let d = try container.decode(String.self, forKey: .date)
		var date = Date()
		if let epoch = Double(d) {
			date = Date(timeIntervalSince1970: epoch)
		}
		let isFixed = try container.decode(Bool.self, forKey: .isFixed)
		let cycleType = try container.decode(Int.self, forKey: .cycleType)
		let cycleValue = try container.decode(Int.self, forKey: .cycleValue)
		let decodedTags =  try container.decode([Tag].self, forKey: .tags)
		let t = List<Tag>()
		t.append(objectsIn: decodedTags)
		
		self.init(id: id, amount: amount, date: date, isFixed: isFixed, cycleType: cycleType, cycleValue: cycleValue, tags: t)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(amount, forKey: .amount)
		try container.encode(date, forKey: .date)
		try container.encode(isFixed, forKey: .isFixed)
		try container.encode(cycleType, forKey: .cycleType)
		try container.encode(cycleValue, forKey: .cycleValue)
		try container.encode(tags.map({ $0 }), forKey: .tags)
	}
	
	required init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}
	
	required init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}
	
	override class func primaryKey() -> String? {
		return "id"
	}
	//	override static func ignoredProperties() -> [String] {
	//		return ["isFixed", "cycleType"]
	//	}
}

// MARK: Convenience initializers
extension Item {
	
	convenience init(data: Data) throws {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .millisecondsSince1970
		let me = try decoder.decode(Item.self, from: data)
		self.init(id: me.id, amount: me.amount, date: me.date, isFixed: me.isFixed, cycleType: me.cycleType, cycleValue: me.cycleValue, tags: me.tags)
	}
	
	convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
		guard let data = json.data(using: encoding) else {
			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
		}
		try self.init(data: data)
	}
	
	convenience init(fromURL url: URL) throws {
		try self.init(data: try Data(contentsOf: url))
	}
	
	func jsonData() throws -> Data {
		return try JSONEncoder().encode(self)
	}
	
	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
		return String(data: try self.jsonData(), encoding: encoding)
	}
	
}

extension Array where Element == Items.Element {
	
	init(data: Data) throws {
		self = try JSONDecoder().decode(Items.self, from: data)
	}
	
	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
		guard let data = json.data(using: encoding) else {
			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
		}
		try self.init(data: data)
	}
	
	init(fromURL url: URL) throws {
		try self.init(data: try Data(contentsOf: url))
	}
	
	func jsonData() throws -> Data {
		return try JSONEncoder().encode(self)
	}
	
	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
		return String(data: try self.jsonData(), encoding: encoding)
	}
	
}

