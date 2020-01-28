//
//  UIButtonExtender.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 27/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonExtension: UIButton {

	override func layoutSubviews() {
		super.layoutSubviews()
		updateCornerRadius()
	}

	@IBInspectable var borderWidth: CGFloat {
		set {
			layer.borderWidth = newValue
		}
		get {
			return layer.borderWidth
		}
	}

	@IBInspectable var roundedCorners: Bool = false {
		didSet {
			self.updateCornerRadius()
		}
	}

	func updateCornerRadius() {
		layer.cornerRadius = roundedCorners ? frame.size.height / 2 : 0
	}

	@IBInspectable var cornerRadius: CGFloat {
		set {
			layer.cornerRadius = newValue
		}
		get {
			return layer.cornerRadius
		}
	}

	@IBInspectable var borderColor: UIColor? {
		set {
			guard let uiColor = newValue else { return }
			layer.borderColor = uiColor.cgColor
		}
		get {
			guard let color = layer.borderColor else { return nil }
			return UIColor(cgColor: color)
		}
	}
}
