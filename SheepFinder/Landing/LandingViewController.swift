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
		if DJI.main.isRegisteredWithSDK() {
			SDKRegisteredStatusLabel.text = "SDK (v\(DJI.main.getSDKVersion())) registered successfully"
		} else {
			SDKRegisteredStatusLabel.text = "SDK is not registered"
		}
	}

	private func showConnectedProductStatus() {
		var message: String = "No connected product"
		NSLog(DJI.main.getConnectedProduct()?.model ?? "No product")
		if let product = DJI.main.getConnectedProduct() {
			message = product.model ?? "Product found, but no model"
		}
		connectedProductLabel.text = message
		CoordinateManager.manager.activateHomeLocation()
	}


	// MARK: Actions

	@IBAction func refreshStateButton(_ sender: UIButton) {
		self.showConnectedProductStatus()
		self.showSDKRegisteredStatus()
	}

	@IBAction func navigateToMain(_ sender: UIButtonExtension) {
		if let nc = self.navigationController {

			nc.setViewControllers([MainViewController.instantiate(fromAppStoryboard: .Main)], animated: true)
		}

	}


}

