//
//  Globals.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 1.04.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
	static let didVerifiedItem = Notification.Name("itemVerified")
}

class Constants {
	//TODO: Localization
	static let namesOfDays: [String] = ["Undefined", "Monday", "Thuesday", "Wednesday",
										"Thursday", "Friday", "Saturday", "Sunday"]
	static let tintColor: UIColor = UIColor(netHex: 0x3478F6)
}

class GlobalAlertController {

	static func showSingleActionAlert(title: String = "",
									  message: String = "",
									  preferredStyle: UIAlertController.Style = .alert,
									  positiveActionTitle: String = "Ok",
									  positiveActionStyle: UIAlertAction.Style = .cancel,
									  positiveAction: ((UIAlertAction) -> Swift.Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		let action = UIAlertAction(title: positiveActionTitle, style: positiveActionStyle, handler: positiveAction)
		alert.addAction(action)
		Dispatch.main {
			Utilities.findTopController().present(alert, animated: true, completion: nil)
		}
	}

	static func showTwoActionAlert(title: String = "",
								   message: String = "",
								   preferredStyle: UIAlertController.Style = .alert,
								   positiveActionTitle: String = "Ok",
								   positiveActionStyle: UIAlertAction.Style = .default,
								   positiveAction: ((UIAlertAction) -> Void)? = nil,
								   negativeActionTitle: String = "Cancel",
								   negativeActionStyle: UIAlertAction.Style = .cancel,
								   negativeAction: ((UIAlertAction) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		let positiveAct = UIAlertAction(title: positiveActionTitle, style: positiveActionStyle, handler: positiveAction)
		let negativeAct = UIAlertAction(title: negativeActionTitle, style: negativeActionStyle, handler: negativeAction)
		alert.addAction(positiveAct)
		alert.addAction(negativeAct)
		Dispatch.main {
			Utilities.findTopController().present(alert, animated: true, completion: nil)
		}
	}

}
