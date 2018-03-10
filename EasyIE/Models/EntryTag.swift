//
//  EntryTag.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//
import RealmSwift

struct EntryTag {
	var id: Int
	var value: String
	
	init(id: Int, value: String) {
		self.id = id
		self.value = value
	}
}

extension EntryTag: SuggestionValue {
	static func ==(lhs: EntryTag, rhs: EntryTag) -> Bool {
		return lhs.id == rhs.id
	}
	
	// Required by `InputTypeInitiable`, can always return nil in the SuggestionValue context.
	init?(string stringValue: String) {
		return nil
	}
	
	// Text that is displayed as a completion suggestion.
	var suggestionString: String {
		return "\(value)"
	}
}

class EntryTagObject: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var value: String = ""
	
}
public protocol Persistable {
	associatedtype ManagedObject: RealmSwift.Object
	init(managedObject: ManagedObject)
	func managedObject() -> ManagedObject
}

extension EntryTag: Persistable {
	public init(managedObject: EntryTagObject) {
		id = managedObject.id
		value = managedObject.value
	}
	public func managedObject() -> EntryTagObject {
		let character = EntryTagObject()
		character.id = id
		character.value = value
		return character
	}
}
