//
//  DJIProductCommunicationManager.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 24/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK


class DJIProductCommunicationManager: NSObject, DJISDKManagerDelegate {

	let bridgeAppIP: String? = "10.22.33.184"

	func registerWithSDK() {
		let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String

		guard appKey != nil && !appKey!.isEmpty else {
			NSLog("Please enter a valid app key in the info.plist file")
			return
		}

		DJISDKManager.registerApp(with: self)
	}

	func productConnected(_ product: DJIBaseProduct?) {
		NSLog("Product Connected")
		NSLog(product?.model ?? "No product information")
	}

	func productDisconnected() {
		NSLog("Product Disconnected")
	}

	func appRegisteredWithError(_ error: Error?) {
		var message = "Register App Successed!"
		if (error != nil) {
			message = "Register app failed! Please enter your app key and check the network."
		} else if bridgeAppIP != nil {
			DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeAppIP!)
		}
		NSLog(message)
	}

	func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
		NSLog("Download database : \n%lld/%lld" + String(progress.completedUnitCount), progress.totalUnitCount)
	}
}
