//
//  EntryDB.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import RealmSwift

class EntryDB {
	
	static func getBy(id: String) -> Entry? {
		return RealmHelper.helper.getObject(by: id, type: Entry.self) as? Entry
	}
	
	static func getAll() -> [Entry] {
		let entries = Array(RealmHelper.helper.getObjects(type: Entry.self)) as? [Entry] ?? [Entry]()
		return entries
	}
	
	static func insert(_ entry: Entry) {
		RealmHelper.helper.insert(entry)
		TagDB.insert(entry.tags.map({ $0 }))
	}
	
	static func insert(_ entries: [Entry]) {
		var tags = [Tag]()//entries.map({ $0.tags })
		entries.forEach({
			if $0.tags.count > 0 {
				tags.append(contentsOf: $0.tags)
			}
		})
		RealmHelper.helper.insert(entries)
		TagDB.insert(tags)
	}
	
	static func delete(id: String) {
		if let entry = getBy(id: id){
			RealmHelper.helper.delete(entry)
		}
	}
	
	static func clear() {
		RealmHelper.helper.deleteAll(RealmHelper.helper.getObjects(type: Entry.self))
	}
}

