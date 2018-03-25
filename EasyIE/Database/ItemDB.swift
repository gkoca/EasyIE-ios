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
		let items = Array(RealmHelper.helper.getObjects(type: Item.self)) as? [Item] ?? [Item]()
		return items
	}
	
	static func insert(_ item: Item, success: @escaping (() -> Void)) {
		RealmHelper.helper.insert(item) {
			print("item added")
			success()
		}
	}
	
	//TODO: callback for multiple insert
	static func insert(_ items: [Item]) {
		RealmHelper.helper.insert(items)
	}
	
	//TODO: callback for delete
	static func delete(id: String) {
		if let entry = getBy(id: id){
			RealmHelper.helper.delete(entry)
		}
	}
	
	//TODO: callback for clear
	static func clear() {
		RealmHelper.helper.deleteAll(RealmHelper.helper.getObjects(type: Item.self))
	}
}

