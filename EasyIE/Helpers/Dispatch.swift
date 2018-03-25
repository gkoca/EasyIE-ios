//
//  Dispatch.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 25.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation

class Dispatch {
	
	static func main(_ block : @escaping ()->()) {
		DispatchQueue.main.async(execute: block)
	}
	
	static func background(_ block : @escaping ()->()) {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: block)
	}
	
	static func main(after seconds: Double, block : @escaping ()->()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			block()
		}
	}
	
	static func mainSync(_ block : @escaping ()->()) {
		DispatchQueue.main.sync {
			block()
		}
	}
}
