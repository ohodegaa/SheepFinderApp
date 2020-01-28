//
//  AppStoryboard.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 27/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit


extension UIViewController {

	// Not using static as it wont be possible to override to provide custom storyboardID then
	class var storyboardID: String {

		return "\(self)"
	}

	static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {

		return appStoryboard.viewController(viewControllerClass: self)
	}

	static func go(fromAppStoryboard appStoryboard: AppStoryboard) -> Void {
		let viewController = appStoryboard.viewController(viewControllerClass: self)
		UIApplication.shared.windows.first?.rootViewController = viewController
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}
}


enum AppStoryboard: String {

	case Main, Landing

	var instance: UIStoryboard {

		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}

	func viewController<T : UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {

		let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

		guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {

			fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
		}

		return scene
	}

	func initialViewController() -> UIViewController? {
		return instance.instantiateInitialViewController()
	}
}
