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
		let error = DJISDKManager.missionControl()?.scheduleElement(DJIShootPhotoAction())

		if error != nil {
			NSLog("Error when scheduling takeoff: \(error!)")
		}
	}

	@IBAction func addLandAction(_ sender: UIButtonExtension) {
		let error = DJISDKManager.missionControl()?.scheduleElement(DJIRecordVideoAction())
		if error != nil {
			NSLog("Error when scheduling landing: \(error!)")
		}
	}
	@IBAction func executeMission(_ sender: UIButtonExtension) {
		DJISDKManager.missionControl()?.addListener("hello-world", toTimelineProgressWith: { (event: DJIMissionControlTimelineEvent, element: DJIMissionControlTimelineElement?, error: Error?, info: Any?) in
			NSLog("halla balla")
			NSLog(element?.debugDescription ?? "No element")
			NSLog("\(event.rawValue)")
			NSLog(error.debugDescription)
			NSLog("\(info ?? "No info")")
		})

	}



}
