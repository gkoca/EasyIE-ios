//
//  TagViewModel.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 25.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

class TagViewModel: NSObject {
	
	private var tags = [Tag]()
	
	func loadTags() {
		tags = TagDB.getAllTags()
	}
	
	 func getAllTagsAsStringArray() -> [String] {
		return tags.map({ return $0.value })
	}
}
