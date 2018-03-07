//
//  Entry.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Entry: Object, Decodable {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var amount: Double = 0.0
	@objc dynamic var detail: String = ""
	@objc dynamic var date: Date = Date()
	
	enum EntryCodingKeys: String, CodingKey {
		case id
		case amount
		case detail
		case date
	}
	
	convenience required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: EntryCodingKeys.self)
		let id = try container.decode(String.self, forKey: .id)
		let amount = try container.decode(Double.self, forKey: .amount)
		let detail = try container.decode(String.self, forKey: .detail)
		let dateString = try container.decode(String.self, forKey: .date)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/mm/yyyy"
		let date = dateFormatter.date(from: dateString) ?? Date()
		self.init(id: id, amount: amount, detail: detail, date: date)
		
	}
	
	convenience init(id: String = UUID().uuidString, amount: Double = 0.0, detail: String = "", date: Date = Date()) {
		self.init()
		self.id = id
		self.amount = amount
		self.detail = detail
		self.date = date
	}
	
	required init() {
		super.init()
	}
	
	required init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}
	
	required init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
