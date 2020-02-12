//
//  FlightControlLayoutViewController.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 28/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import MapKit

class MissionPlannerViewController: UIViewController {

	// MARK: Private properties
	private let locationManager = CLLocationManager()
	private var currentCoordinate: CLLocationCoordinate2D?

	private var polygon: MKPolygon = MKPolygon()
	private var polygonPoints: [CLLocationCoordinate2D] = []


	// MARK: Outlets
	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureLocationServices()
		self.mapView.delegate = self

		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setUpMapView()
	}



	// MARK: Private methods


	// MapView

	func setUpMapView() {

		// Set up mapView gesture recognizer
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onMapTapped(gestureRecognizer:)))
		self.mapView.addGestureRecognizer(gestureRecognizer)
	}

	@objc private func onMapTapped(gestureRecognizer: UITapGestureRecognizer) {
		let locationInView = gestureRecognizer.location(in: self.mapView)
		let coordinate = self.mapView.convert(locationInView, toCoordinateFrom: mapView)
		self.polygonPoints.append(coordinate)
		self.updatePolygon(with: coordinate)
		self.updateAnnotations(with: coordinate)

	}

	private func updatePolygon(with coordinate: CLLocationCoordinate2D) {
		let newPolygon: MKPolygon = MKPolygon(coordinates: self.polygonPoints, count: self.polygonPoints.count)
		self.mapView.addOverlay(newPolygon)
		self.mapView.removeOverlay(self.polygon)
		self.polygon = newPolygon
	}

	private func updateAnnotations(with coordinate: CLLocationCoordinate2D) {
		let newAnnotation: MKPointAnnotation = MKPointAnnotation()
		newAnnotation.coordinate = coordinate
		self.mapView.addAnnotation(newAnnotation)
	}




	// MARK: Location
	private func configureLocationServices() {
		locationManager.delegate = self

		let status = CLLocationManager.authorizationStatus()

		if status == .notDetermined {
			locationManager.requestAlwaysAuthorization()
		} else if status == .authorizedAlways || status == .authorizedWhenInUse {
			self.beginLocationUpdate(locationManager: locationManager)
		}
	}


	private func beginLocationUpdate(locationManager: CLLocationManager) {
		mapView.showsUserLocation = true
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
	}

	private func zoomToLocation(with coordinate: CLLocationCoordinate2D) {
		let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
		mapView.setRegion(region, animated: true)
	}
}



extension MissionPlannerViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let overlay = overlay as? MKPolygon {
			let renderer = MKPolygonRenderer(overlay: overlay)
			renderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
			renderer.strokeColor = UIColor.blue
			renderer.lineWidth = 2
			return renderer
		}
		else {
			return MKOverlayRenderer(overlay: overlay)
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		else {
			let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "location")
			return annotationView
		}
	}
}


extension MissionPlannerViewController: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Get latest location!")

		guard let latesLocation = locations.last else { return }

		if currentCoordinate == nil {
			self.zoomToLocation(with: latesLocation.coordinate)
		}

		currentCoordinate = latesLocation.coordinate
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			self.beginLocationUpdate(locationManager: manager)
		}

	}

}
