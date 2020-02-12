//
//  Testflight.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 28/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import DJISDK
import DJIUXSDK

class TestflightViewController: UIViewController {

	// MARK: Properties

	var started: Bool = false

	@IBOutlet weak var addTakeoffButton: UIButtonExtension!
	@IBOutlet weak var addLandButton: UIButtonExtension!
	@IBOutlet weak var executeButton: UIButtonExtension!



	// MARK: Private Methods

	func takeOffHasCompleted(error: Error?) {
		if error != nil {
			NSLog("Takeoff completion gave an error: \(error!)")
			return
		}
		NSLog("Aircraft has taken off")
	}

	func landingHasCompleted(error: Error?) {
		if error != nil {
			NSLog("Landing completion gave an error: \(error!)")
			return
		}
		NSLog("Aircraft has landed")
	}

	// MARK: Actions
	@IBAction func addTakeoffAction(_ sender: UIButtonExtension) {
		NSLog("TakeOff")
		let missionControl = DJISDKManager.missionControl()
		missionControl?.scheduleElement(DJITakeOffAction())
		missionControl?.scheduleElement(DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418337, longitude: 10.402769), altitude: 5)!)
		missionControl?.scheduleElement(DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418447, longitude: 10.403263), altitude: 5)!)
		missionControl?.scheduleElement(DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418598, longitude: 10.403097), altitude: 5)!)
		missionControl?.scheduleElement(DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418531, longitude: 10.402622), altitude: 5)!)
		missionControl?.scheduleElement(DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 63.418337, longitude: 10.402769), altitude: 5)!)
		missionControl?.scheduleElement(DJILandAction())
	}

	@IBAction func addLandAction(_ sender: UIButtonExtension) {
		let error = DJISDKManager.missionControl()?.scheduleElement(DJIRecordVideoAction())
		if error != nil {
			NSLog("Error when scheduling landing: \(error!)")
		}
	}
	@IBAction func executeMission(_ sender: UIButtonExtension) {
		DJISDKManager.missionControl()?.startTimeline()
		NSLog(CoordinateManager.manager.appLocation.coordinate.longitude.description)
	}



}
