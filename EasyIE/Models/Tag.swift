//
//  Tag.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 25.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Tag: Object, Codable {
	
	@objc dynamic var value: String = ""
	let entries = LinkingObjects(fromType: Item.self, property: "tags")
	
	enum CodingKeys: String, CodingKey {
		case value = "value"
	}
	
	init(value: String) {
		super.init()
		self.value = value
	}
	
	required init() {
		super.init()
	}
	
	required init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}
	
	required init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}
	
	override class func primaryKey() -> String? {
		return "value"
	}
	
}

extension Tag {
	
	convenience init(data: Data) throws {
		let me = try JSONDecoder().decode(Tag.self, from: data)
		self.init(value: me.value)
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

