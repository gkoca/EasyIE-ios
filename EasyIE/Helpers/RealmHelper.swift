//
//  RealmHelper.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import RealmSwift

class RealmHelper {
	
	static let helper = RealmHelper()
	let realm = try! Realm(configuration: getConfiguration())
	
	private static func getConfiguration() -> Realm.Configuration {
		var config = Realm.Configuration()
		config.deleteRealmIfMigrationNeeded = true
		return config
	}
	
	func update(block:(()->())) {
		try! realm.write {
			block()
		}
	}
	
	func insert(_ object: Object) {
		update {
			realm.add(object, update: true)
		}
	}
	
	func insert(_ objects: [Object]) {
		update {
			realm.add(objects, update: true)
		}
	}
	
	func delete(_ object: Object) {
		update {
			realm.delete(object)
		}
	}
	
	func deleteAll(_ objects: Results<Object>) {
		update {
			realm.delete(objects)
		}
	}
	
	func getObject(by primaryKey: String, type: Object.Type) -> Object? {
		return realm.object(ofType: type, forPrimaryKey: primaryKey)
	}
	
	func getObject(by primaryKey: UUID, type: Object.Type) -> Object? {
		return realm.object(ofType: type, forPrimaryKey: primaryKey)
	}
	
	func getObjects(type: Object.Type) -> Results<Object> {
		return realm.objects(type)
	}
	
}
