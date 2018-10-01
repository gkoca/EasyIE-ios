//
//  TagDB.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import RealmSwift

class TagDB {

	static func getBy(value: String) -> Tag? {
		return RealmHelper.helper.getObject(by: value, type: Tag.self) as? Tag
	}

	static func getAllTags() -> [Tag] {
		let tags = Array(RealmHelper.helper.getObjects(type: Tag.self)) as? [Tag] ?? [Tag]()
		return tags
	}

	static func insert(_ tag: Tag) {
		RealmHelper.helper.insert(tag) {
			print("tag added")
		}
	}

	static func insert(_ tags: [Tag]) {
		RealmHelper.helper.insert(tags)
	}

	static func delete(value: String) {
		if let tag = getBy(value: value) {
			RealmHelper.helper.delete(tag)
		}
	}

	static func clear() {
		RealmHelper.helper.deleteAll(RealmHelper.helper.getObjects(type: Tag.self))
	}
}
