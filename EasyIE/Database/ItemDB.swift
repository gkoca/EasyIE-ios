//
//  ItemDB.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import RealmSwift

class ItemDB {
	
	static func getBy(id: String) -> Item? {
		return RealmHelper.helper.getObject(by: id, type: Item.self) as? Item
	}
	
	static func getAll() -> [Item] {
		let entries = Array(RealmHelper.helper.getObjects(type: Item.self)) as? [Item] ?? [Item]()
		return entries
	}
	
	static func insert(_ entry: Item) {
		RealmHelper.helper.insert(entry)
//		TagDB.insert(entry.tags.map({ $0 }))
	}
	
	static func insert(_ entries: [Item]) {
//		var tags = [Tag]()//items.map({ $0.tags })
//		entries.forEach({
//			if $0.tags.count > 0 {
//				tags.append(contentsOf: $0.tags)
//			}
//		})
		RealmHelper.helper.insert(entries)
//		TagDB.insert(tags)
	}
	
	static func delete(id: String) {
		if let entry = getBy(id: id){
			RealmHelper.helper.delete(entry)
		}
	}
	
	static func clear() {
		RealmHelper.helper.deleteAll(RealmHelper.helper.getObjects(type: Item.self))
	}
}

