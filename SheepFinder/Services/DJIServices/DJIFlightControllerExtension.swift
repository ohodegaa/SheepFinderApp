//
//  DJIFlightControllerExtension.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 28/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK

extension DJI {
	func getFlightController() -> DJIFlightController? {
		return self.flightController
	}
}
