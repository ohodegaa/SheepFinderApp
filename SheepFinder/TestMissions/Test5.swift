//
//  Test5.swift
//  SheepFinder
//
//  Created by Jonathan on 04/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//


import DJISDK

class Test5: TestMission {
	var addActions: [DJIMissionAction] = [
		DJITakeOffAction(),
		DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418988, longitude: 10.406780), altitude: 10)!,
		DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.419212, longitude: 10.406369), altitude: 10)!,
		DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.419297, longitude: 10.406156), altitude: 10)!,
		DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418988, longitude: 10.406780), altitude: 10)!,
		DJILandAction(),
	];

	override init() {
		super.init()
		self.actions = addActions;
	};
}
