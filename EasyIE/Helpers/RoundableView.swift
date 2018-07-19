//
//  RoundableView.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 10.05.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

@IBDesignable
class RoundableView: UIView {
	@IBInspectable var RoundableViewBorderColor: UIColor = UIColor.white {
		didSet {
			self.layer.borderColor = RoundableViewBorderColor.cgColor
		}
	}
	@IBInspectable var RoundableViewBorderWidth: CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = RoundableViewBorderWidth
		}
	}
	@IBInspectable var RoundableViewCornerRadius: CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = RoundableViewCornerRadius
		}
	}
}
