//
//  STag.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 25.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

struct STag {
	var value: String
	
	init(value: String) {
		self.value = value
	}
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
