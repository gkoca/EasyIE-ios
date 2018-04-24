//
//  Saving.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 24.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Realm
import RealmSwift

typealias Savings = [Saving]

class Saving: Object {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var target: Double = 0.0
	@objc dynamic var tag: Tag = Tag()
	
	var items = List<SavingItem>()
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
