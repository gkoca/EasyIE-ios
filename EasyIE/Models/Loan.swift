//
//  Loan.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 24.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Realm
import RealmSwift

class Loan: Object {
	
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var totalAmount: Double = 0.0
	@objc dynamic var numberOfParts: Int = 1
	@objc dynamic var interestRate: Double = 0.0
	@objc dynamic var startDate: Date = Date()
	@objc dynamic var endDate: Date = Date()
	@objc dynamic var tag: Tag?
	
	var items = List<LoanItem>()
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
