//
//  CustomPointAnnotation.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 13/02/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
	public var index: Int!

	init(coordinate: CLLocationCoordinate2D, index: Int) {
		super.init()
		self.coordinate = coordinate
		self.index = index
	}
}
