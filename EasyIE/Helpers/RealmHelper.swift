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
		let documentDirectory = try! FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		let fileURL = documentDirectory.appendingPathComponent("easyie.realm")
		print("Create realm configuration with file url \(fileURL)")
		return Realm.Configuration(fileURL: fileURL, readOnly: false, schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
	}
	
	func update(block:(()->())) {
		try! realm.write {
			block()
		}
	}
	
	func insert(_ object: Object, success: @escaping (() -> Void)) {
		let group = DispatchGroup()
		group.enter()
		let observerToken = realm.observe { (_, _) in
			success()
			group.leave()
		}
		update {
			realm.add(object, update: true)
		}
		group.notify(queue: .main) {
			observerToken.invalidate()
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
	
	//TODO: investigate
	func getObject(by primaryKey: UUID, type: Object.Type) -> Object? {
		return realm.object(ofType: type, forPrimaryKey: primaryKey)
	}
	
	func getObjects(type: Object.Type) -> Results<Object> {
		return realm.objects(type)
	}
	
}
