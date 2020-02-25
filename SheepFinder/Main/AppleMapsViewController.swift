//
//  FlightControlLayoutViewController.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 28/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import MapKit
import os

class AppleMapsViewController: UIViewController, UIGestureRecognizerDelegate {

	// MARK: Private properties

	private var polygon: MKPolygon = MKPolygon()
	private var annotations: [MKPointAnnotation] = []


	// MARK: Outlets
	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.mapView.delegate = self
		self.setUpGestureRecognizers()
	}

	override func viewDidLayoutSubviews() {
		self.zoomToLocation(with: CoordinateManager.manager.appLocation.coordinate)
	}


	// MARK: MapView

	func setUpGestureRecognizers() {
		// Set up mapView gesture recognizer
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTap(sender:)))
		longPressGestureRecognizer.delegate = self
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
		tapGestureRecognizer.delegate = self

		self.mapView.addGestureRecognizer(longPressGestureRecognizer)
		self.mapView.addGestureRecognizer(tapGestureRecognizer)
	}


	// MARK: Gestures

	@objc private func handleTap(sender: UITapGestureRecognizer) {
		print("Tap: \(sender.state.rawValue)")
	}

	@objc private func handleLongTap(sender: UILongPressGestureRecognizer) {
		if (sender.state == .began) {
			let locationInView = sender.location(in: self.mapView)
			let coordinate = self.mapView.convert(locationInView, toCoordinateFrom: mapView)
			self.addAnnotationToMap(with: coordinate)
			self.updatePolygon()
		} else if (sender.state == .ended) {
			self.mapView.becomeFirstResponder()
			self.mapView.accessibilityActivate()
			print("\(self.mapView.isFirstResponder)")
		}
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return !(touch.view is MKPinAnnotationView)
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
		print("press")
		return true
	}

	private func updatePolygon() {
		let coordinates = self.annotations.map({ $0.coordinate })

		// Sort coordinates to create path surrounding the points:
		let hull = sortConvex(input: coordinates)

		let newPolygon: MKPolygon = MKPolygon(coordinates: hull, count: hull.count)
		self.mapView.addOverlay(newPolygon)
		self.mapView.removeOverlay(self.polygon)
		self.polygon = newPolygon
	}

	private func addAnnotationToMap(with coordinate: CLLocationCoordinate2D) {
		let newAnnotation: MKPointAnnotation = MKPointAnnotation()
		newAnnotation.coordinate = coordinate
		newAnnotation.title = "Pin \(self.annotations.count)"
		self.annotations.append(newAnnotation)
		self.mapView.addAnnotation(newAnnotation)
	}

	// MARK: Drag handling

	private func updatePoint(annotation: MKPointAnnotation, with coordinate: CLLocationCoordinate2D) {
		annotation.coordinate = coordinate
		self.updatePolygon()
	}


	private func zoomToLocation(with coordinate: CLLocationCoordinate2D) {
		let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
		mapView.setRegion(region, animated: true)
	}
}



extension AppleMapsViewController: MKMapViewDelegate {

	// MARK: Overlay (polygon)
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		print("Rendering overlay (polygon)")
		if let overlay = overlay as? MKPolygon {
			let renderer = MKPolygonRenderer(overlay: overlay)
			renderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
			renderer.strokeColor = UIColor.blue
			renderer.lineWidth = 2
			return renderer
		}
		else {
			// Not a polygon
			return MKOverlayRenderer(overlay: overlay)
		}
	}

	// MARK: Annotation (pin)
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if !(annotation is MKPointAnnotation) {
			return nil
		}
		print("Adding annotation")
		let reuseId = "annotationPin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
		}
		pinView!.isDraggable = true
		pinView!.animatesDrop = true
		pinView!.isEnabled = true
		pinView!.pinTintColor = .blue
		return pinView
	}

	// To avoid multiple taps before drag is triggered
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		print("deselect")
		if let pinView = view as? MKPinAnnotationView {
			pinView.pinTintColor = .blue
		}
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		print("select")
		if let pinView = view as? MKPinAnnotationView {
			pinView.pinTintColor = .green
		}
	}

	// MARK: Annotation drag handler

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
		print("Annotation state changed to: \(newState.rawValue)")

		switch newState {
		case .ending, .canceling:
			if let annotation = view.annotation as? MKPointAnnotation {
				self.updatePoint(annotation: annotation, with: annotation.coordinate)
			}
			break
		case .dragging, .starting:
			if let pinView = view as? MKPinAnnotationView {
				pinView.pinTintColor = .green
			}
			break
		default:
			break
		}
	}
}
