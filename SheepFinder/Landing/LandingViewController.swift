//
//  LandingViewController.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 23/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import DJISDK

@IBDesignable
class LandingViewController: UIViewController {

	// MARK: Properties

	@IBOutlet weak var SDKRegisteredStatusLabel: UILabel!
	@IBOutlet weak var connectedProductLabel: UILabel!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: Private Methods

	private func showSDKRegisteredStatus() {
		if dji.appRegistered, let version = dji.sdkVersion {
			SDKRegisteredStatusLabel.text = "SDK (v\(version)) registered successfully"
		} else {
			SDKRegisteredStatusLabel.text = "SDK is not registered"
		}
	}

	private func showConnectedProductStatus() {
		connectedProductLabel.text = dji.product?.model ?? "No connected product found"
	}


	// MARK: Actions

	@IBAction func refreshStateButton(_ sender: UIButton) {
		dji.registerWithSDK()
		self.showConnectedProductStatus()
		self.showSDKRegisteredStatus()
	}

	@IBAction func navigateToMain(_ sender: UIButtonExtension) {
		if let nc = self.navigationController {

			nc.setViewControllers([MainViewController.instantiate(fromAppStoryboard: .Main)], animated: true)
		}

	}


}

