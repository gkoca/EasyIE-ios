//
//  GlobalAlertController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 28.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class GlobalAlertController {
	
	static func showSingleActionAlert(title: String = "",
									  message: String = "",
									  preferredStyle: UIAlertControllerStyle = .alert,
									  positifActionTitle: String = "Ok",
									  positifActionStyle: UIAlertActionStyle = .cancel,
									  positifAction: ((UIAlertAction) -> Swift.Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		let positifAct = UIAlertAction(title: positifActionTitle, style: positifActionStyle, handler: positifAction)
		alert.addAction(positifAct)
		Dispatch.main {
			Utilities.findTopController().present(alert, animated: true, completion: nil)
		}
	}
	
	static func showTwoActionAlert(title: String = "",
								   message: String = "",
								   preferredStyle: UIAlertControllerStyle = .alert,
								   positifActionTitle: String = "Ok",
								   positifActionStyle: UIAlertActionStyle = .default,
								   positifAction: ((UIAlertAction) -> Void)? = nil,
								   negativeActionTitle: String = "Cancel",
								   negativeActionStyle: UIAlertActionStyle = .cancel,
								   negativeAction: ((UIAlertAction) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		let positifAct = UIAlertAction(title: positifActionTitle, style: positifActionStyle, handler: positifAction)
		let negativeAct = UIAlertAction(title: negativeActionTitle, style: negativeActionStyle, handler: negativeAction)
		alert.addAction(positifAct)
		alert.addAction(negativeAct)
		Dispatch.main {
			Utilities.findTopController().present(alert, animated: true, completion: nil)
		}
	}
	
}
