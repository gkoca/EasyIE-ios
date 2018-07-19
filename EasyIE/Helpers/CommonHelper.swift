//
//  CommonHelper.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit
import RealmSwift

class Utilities {
	static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	static func findTopController() -> UIViewController {
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			return topController
		} else {
			return (UIApplication.shared.keyWindow?.rootViewController)!
		}
	}
}

fileprivate struct DeviceType {
	static let isIPad = UIDevice.current.model == "iPad"
}

fileprivate enum Storyboard : String {
	case main = "Main"
	case mainIPad = "MainIPad"
}

fileprivate extension UIStoryboard {
	
	static func loadFromMain(_ identifier: String) -> UIViewController {
		return load(from: .main, identifier: identifier)
	}
	
	// optionally add convenience methods for other storyboards here ...
	
	// ... or use the main loading method directly when
	// instantiating view controller from a specific storyboard
	static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
		let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
		return uiStoryboard.instantiateViewController(withIdentifier: identifier)
	}
}

// MARK: App View Controllers
extension UIStoryboard {
	class func loadViewController() -> UIViewController {
		return load(from: DeviceType.isIPad ? .mainIPad : .main, identifier: "ItemViewController")
	}
}

// MARK: UIColor
extension UIColor {
	
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
	
	struct AppColor {
		static let arrowDark = UIColor(netHex: 0x707070)
		static let colorIncome = UIColor(netHex: 0x388e3c)
		static let colorIncomeDark = UIColor(netHex: 0x00600f)
		static let colorExpense = UIColor(netHex: 0xd32f2f)
		static let colorExpenseDark = UIColor(netHex: 0x9a0007)
		
		static let colorPrimary = UIColor(netHex: 0x880e4f)
		static let colorPrimaryLight = UIColor(netHex: 0xbc477b)
		static let colorPrimaryDark = UIColor(netHex: 0x560027)
		static let colorAccent = UIColor(netHex: 0x1a237e)
		static let colorAccentLight = UIColor(netHex: 0x534bae)
		static let colorAccentDark = UIColor(netHex: 0x000051)
		static let primaryTextColor = UIColor(netHex: 0xffffff)
		static let secondaryTextColor = UIColor(netHex: 0xffffff)
	}
}

// MARK: Array
// usage : objectsArray = objectsArray.filterDuplicate{ ($0.name,$0.age) }
extension Array {
	func filterDuplicate<T>(_ keyValue:(Element)->T) -> [Element] {
		var uniqueKeys = Set<String>()
		return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
	}
}

// MARK: Persistable
public protocol Persistable {
	associatedtype ManagedObject: RealmSwift.Object
	init(managedObject: ManagedObject)
	func managedObject() -> ManagedObject
}

// MARK: Date
extension Date {
	func getNextMonth() -> Date? {
		return Calendar.current.date(byAdding: .month, value: 1, to: self)
	}
	func getPreviousMonth() -> Date? {
		return Calendar.current.date(byAdding: .month, value: -1, to: self)
	}
}


