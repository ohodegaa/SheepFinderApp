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
        let test1: Test1 = Test1();
        test1.scheduleMission(control: missionControl)
	}

    @IBAction func addLandAction(_ sender: UIButtonExtension) {
		let missionControl = DJISDKManager.missionControl()
        let test2: Test2 = Test2();
        test2.scheduleMission(control: missionControl)
	}
    
  
    @IBAction func test3(_ sender: UIButtonExtension) {
        let missionControl = DJISDKManager.missionControl()
        let test3: Test3 = Test3();
        test3.scheduleMission(control: missionControl)
    }
    
    @IBAction func test4(_ sender: UIButtonExtension) {
        let missionControl = DJISDKManager.missionControl()
        let test4: Test4 = Test4();
        test4.scheduleMission(control: missionControl)
    }
    @IBAction func test5(_ sender: UIButtonExtension) {
        let missionControl = DJISDKManager.missionControl()
        let test5: Test5 = Test5();
        test5.scheduleMission(control: missionControl)
    }
    
    @IBAction func test6(_ sender: UIButtonExtension) {
        let missionControl = DJISDKManager.missionControl()
        let test6: Test6 = Test6();
        test6.scheduleMission(control: missionControl)
    }
    
    @IBAction func executeMission(_ sender: UIButtonExtension) {
		DJISDKManager.missionControl()?.startTimeline()
	}

    @IBAction func end(_ sender: UIButtonExtension) {
        DJISDKManager.missionControl()?.stopTimeline()
    }
    

}
