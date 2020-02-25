//
//  GoogleMapsViewController.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 25/02/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import GoogleMaps

let DEFAULT_LOCATION: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 64.6749813, longitude: 15.6851649)
let DEFAULT_ZOOM: Float = 6.0

class GoogleMapsViewController: UIViewController {

	// MARK: Private properties
	private var mapView: GMSMapView!
	private var polygon: GMSPolygon = GMSPolygon()
	private var markers: [GMSMarker] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setUpMap()
	}

	override func viewDidLayoutSubviews() {
		self.zoomToCurrentLocation()
	}

	// MARK: Private methods

	private func setUpMap() {
		// MARK: Init map
		let camera = GMSCameraPosition.camera(withTarget: DEFAULT_LOCATION, zoom: DEFAULT_ZOOM)
		self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		self.mapView.delegate = self
		self.view = self.mapView

		// MARK: Map settings
		self.mapView.settings.myLocationButton = true
		self.mapView.isMyLocationEnabled = true

	}

	private func zoomToCurrentLocation() {
		let location = CoordinateManager.manager.appLocation

		let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14.0)

		self.mapView?.animate(to: camera)

	}
}


extension GoogleMapsViewController: GMSMapViewDelegate {

	// MARK: Tap on map handler

	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		self.addMarker(at: coordinate)
		self.updatePolygon()
	}

	func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
		marker.rotation = 0
		self.updatePolygon()
	}
	
	func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
		marker.rotation = 20
	}

	func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
		self.updatePolygon()
	}

	private func addMarker(at position: CLLocationCoordinate2D) {
		let newMarker = GMSMarker(position: position)
		newMarker.title = "Marker \(self.markers.count + 1)"
		newMarker.map = self.mapView
		newMarker.isDraggable = true
		self.markers.append(newMarker)
	}

	private func updatePolygon() {

		// Get marker positions
		let polygonPath = GMSMutablePath()
		self.markers.forEach({ marker in
			polygonPath.add(marker.position)
		})

		// Init polygon and set up
		self.polygon.path = polygonPath
		self.polygon.fillColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.4)
		self.polygon.strokeColor = .blue	
		self.polygon.strokeWidth = 2

		if self.polygon.map == nil {
			self.polygon.map = self.mapView
		}
	}

}
