//
//  DJI.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 24/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK


let dji = DJI()

class DJI: NSObject, DJISDKManagerDelegate {


	// MARK: Properties

	let bridgeAppIP: String? = nil // "10.22.33.47"

	var appRegistered: Bool = false
	var sdkVersion: String? = nil
	var product: DJIBaseProduct? = nil
	var flightController: DJIFlightController? = nil

	override init() {
		super.init()
		self.registerWithSDK()
		self.initFlightController()
	}

	func registerWithSDK() {
		let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String

		guard appKey != nil && !appKey!.isEmpty else {
			NSLog("Please enter a valid app key in the info.plist file")
			return
		}

		DJISDKManager.registerApp(with: self)
	}

	func initFlightController() {
		self.flightController = DJIFlightController()
	}

	// MARK: DJISDKManager Delegates

	func productConnected(_ product: DJIBaseProduct?) {
		if product != nil {
			NSLog("Product connected")
			self.product = product
		} else {
			NSLog("productConnected called, but no product information found")
		}
	}

	func productDisconnected() {
		NSLog("Product Disconnected")
	}

	func appRegisteredWithError(_ error: Error?) {
		var message = "Register App Successed!"
		if (error != nil) {
			message = "Register app failed! Please enter your app key and check the network."
		} else {
			self.appRegistered = true
			self.sdkVersion = DJISDKManager.sdkVersion()
			if bridgeAppIP != nil {
				DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeAppIP!)
			}
		}
		NSLog(message)
	}

	func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
		NSLog("Download database : \n%lld/%lld" + String(progress.completedUnitCount), progress.totalUnitCount)
	}
}
