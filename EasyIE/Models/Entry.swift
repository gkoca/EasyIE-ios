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

typealias Entries = [Entry]

class Entry: Object, Codable {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var amount: Double = 0.0
	@objc dynamic var date: Date = Date()
	var tags = List<Tag>()

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case amount = "amount"
		case tags = "tags"
		case date = "date"
	}
	
	init(id: String = UUID().uuidString, amount: Double = 0.0, tags: List<Tag> = List<Tag>(), date: Date = Date()) {
		super.init()
		self.id = id
		self.amount = amount
		self.tags = tags
		self.date = date
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
		let decodedTags =  try container.decode([Tag].self, forKey: .tags)
		let t = List<Tag>()
		t.append(objectsIn: decodedTags)
		self.init(id: id, amount: amount, tags: t, date: date)
	}
	
	func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(amount, forKey: .amount)
		try container.encode(date, forKey: .date)
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
	
}

class Tag: Object, Codable {
	
	@objc dynamic var value: String = ""
	let entries = LinkingObjects(fromType: Entry.self, property: "tags")
	
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

struct STag {
	var value: String
	
	init(value: String) {
		self.value = value
	}
}

public protocol Persistable {
	associatedtype ManagedObject: RealmSwift.Object
	init(managedObject: ManagedObject)
	func managedObject() -> ManagedObject
}

extension STag: Persistable {
	
	public init(managedObject: Tag) {
		value = managedObject.value
	}
	
	public func managedObject() -> Tag {
		let tag = Tag(value: value)
		return tag
	}
}

extension STag: SuggestionValue {
	
	static func ==(lhs: STag, rhs: STag) -> Bool {
		return lhs.value == rhs.value
	}
	
	//TODO: examine
	// Required by `InputTypeInitiable`, can always return nil in the SuggestionValue context.
	init?(string stringValue: String) {
		return nil
	}
	
	// Text that is displayed as a completion suggestion.
	var suggestionString: String {
		return "\(value)"
	}
}

// MARK: Convenience initializers

extension Entry {
	convenience init(data: Data) throws {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .millisecondsSince1970
		let me = try decoder.decode(Entry.self, from: data)
		self.init(id: me.id, amount: me.amount, tags: me.tags, date: me.date)
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

extension Array where Element == Entries.Element {
	init(data: Data) throws {
		self = try JSONDecoder().decode(Entries.self, from: data)
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

