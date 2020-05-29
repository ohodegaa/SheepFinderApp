//
//  DoubleExtension.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 18/05/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import Foundation


extension Double {
	/// Rounds the double to decimal places value
	func rounded(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}
