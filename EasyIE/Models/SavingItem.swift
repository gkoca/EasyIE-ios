//
//  SavingItem.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 24.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Realm
import RealmSwift

class SavingItem: Object {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var amount: Double = 0.0
	@objc dynamic var date: Date = Date()
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
