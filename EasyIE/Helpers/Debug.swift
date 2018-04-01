//
//  Debug.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 1.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

class Debug {
	static func printInvestigate(_ file: String, _ line: Int) {
		#if DEBUG
			print("investigate \(file) : \(line)")
		#endif
	}
	
	static func printWrong(_ file: String, _ line: Int) {
		#if DEBUG
			print("Something is wrong \(file) : \(line)")
		#endif
	}
}
