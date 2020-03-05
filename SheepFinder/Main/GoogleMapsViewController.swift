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
	private var selectedMarker: GMSMarker?
	@IBOutlet weak var deleteMarkerButton: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()
		self.setUpMap()
		self.setUpDeleteButton()
	}

	override func viewDidLayoutSubviews() {
		self.zoomToCurrentLocation()
	}

	// MARK: Private methods

	private func setUpDeleteButton() {
		self.deleteMarkerButton.layer.cornerRadius = self.deleteMarkerButton.frame.size.width / 2
	}

	private func setUpMap() {
		// MARK: Init map
		let camera = GMSCameraPosition.camera(withTarget: DEFAULT_LOCATION, zoom: DEFAULT_ZOOM)
		self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
		self.mapView.delegate = self
		//self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.insertSubview(self.mapView, at: 0)

		// MARK: Map settings
		self.mapView.settings.myLocationButton = true
		self.mapView.isMyLocationEnabled = true

	}

	private func zoomToCurrentLocation() {
		let location = CoordinateManager.manager.appLocation

		let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14.0)

		self.mapView?.animate(to: camera)

	}

	// MARK: Delete button

	private func showDeleteButton(for marker: GMSMarker?) {
		self.selectedMarker = marker
		self.deleteMarkerButton.isHidden = false
	}


	@IBAction func deleteMarker(_ sender: UIButton) {
		if let marker = self.selectedMarker {
			marker.map = nil
		}
		self.updatePolygon()
	}

	// MARK: Marker and polygon

	private func addMarker(at position: CLLocationCoordinate2D) {
		let newMarker = GMSMarker(position: position)
		newMarker.title = "Marker \(self.markers.count + 1)"
		newMarker.appearAnimation = .pop
		newMarker.map = self.mapView
		newMarker.isDraggable = true
		self.markers.append(newMarker)
	}

	private func updatePolygon() {

		// Get marker positions
		let polygonPath = GMSMutablePath()
		let markerPositions = self.markers.filter({ $0.map != nil }).map({ $0.position })
		let sortedPositions = sortConvex(input: markerPositions)
		sortedPositions.forEach({ position in
			polygonPath.add(position)
		})

		// Init polygon and set up
		self.polygon.map = nil
		self.polygon = GMSPolygon(path: polygonPath)
		self.polygon.fillColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.3)
		self.polygon.strokeColor = .blue
		self.polygon.strokeWidth = 2

		self.polygon.map = self.mapView
	}

}


extension GoogleMapsViewController: GMSMapViewDelegate {

	// MARK: Tap on map handler

	func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
		self.addMarker(at: coordinate)
		self.updatePolygon()
	}

	func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
		self.deleteMarkerButton.isHidden = true
	}

	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		self.selectedMarker = marker
		self.showDeleteButton(for: marker)
		return false
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



}
