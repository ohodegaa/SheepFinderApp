//
//  GoogleMapsViewController.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 25/02/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import UIKit
import GoogleMaps
import DJISDK

let DEFAULT_LOCATION: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 64.6749813, longitude: 15.6851649)
let DEFAULT_ZOOM: Float = 6.0


class PathPoint {

	public var latitude: Double
	public var longitude: Double
	public var altitude: Double

	init(latitude: Double, longitude: Double, altitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
		self.altitude = altitude
	}

	func asCLLocation2D() -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
	}
}


class GoogleMapsViewController: UIViewController {

	// MARK: Private properties
	private var firstLayoutSubviewsTime = true


	// MARK: Map related properties
	private var mapView: GMSMapView!
	private var polygon: GMSPolygon = GMSPolygon()
	private var selectedMarker: GMSMarker?
	private var markers: [GMSMarker] = []
	private var pathCircles: [GMSCircle] = []

	// MARK: Path properties
	private var path: [PathPoint] = []
	private var pathPolyline: GMSPolyline?
	private var footprintLength: Double = 20
	private var height: Double = 2.0
	private var speed: Double = 2.0

	// MARK: DJI Mission properties
	private var mission: DJIMutableWaypointMission = DJIMutableWaypointMission()
	private var missionOperator: DJIWaypointMissionOperator? = DJISDKManager.missionControl()?.waypointMissionOperator()

	private var useServerHeight: Bool = false

	// MARK: Outlets
	@IBOutlet weak var deleteMarkerButton: UIButton!
	@IBOutlet weak var executeButton: UIButton!
	@IBOutlet weak var downloadButton: UIButton!

	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var useServerHeightLabel: UILabel!
	@IBOutlet weak var speedLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.heightLabel.text = String("Height: \(self.height)")
		self.useServerHeightLabel.text = "Use server height"
		self.speedLabel.text = String("Speed: \(self.speed)")
		self.checkOperatorState()
		self.setUpMap()
		self.setUpButtons()
	}

	override func viewDidLayoutSubviews() {
		if self.firstLayoutSubviewsTime {
			self.zoomToCurrentLocation()
			self.firstLayoutSubviewsTime = false
		}
	}

	// MARK: Private methods

	private func setUpButtons() {
		self.deleteMarkerButton.layer.cornerRadius = self.deleteMarkerButton.frame.size.width / 2

		self.executeButton.layer.cornerRadius = self.executeButton.frame.size.width / 2

		self.downloadButton.layer.cornerRadius = self.downloadButton.frame.size.width / 2
	}

	private func setUpMap() {
		// MARK: Init map
		let camera = GMSCameraPosition.camera(withTarget: DEFAULT_LOCATION, zoom: DEFAULT_ZOOM)
		self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
		self.mapView.delegate = self
		self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.insertSubview(self.mapView, at: 0)

		// MARK: Map settings
		self.mapView.settings.myLocationButton = true
		self.mapView.isMyLocationEnabled = true
		self.mapView.mapType = .satellite

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



	func resetPath() {
		if self.pathPolyline != nil {
			self.pathPolyline!.map = nil
		}
		self.pathCircles.forEach({ circle in
			circle.map = nil
		})
		self.pathCircles = []
		self.path = []
	}

	func getGMSPath() -> GMSMutablePath {
		let gmsPath = GMSMutablePath()
		self.path.forEach({ (point: PathPoint) in
			gmsPath.add(point.asCLLocation2D())
		})
		return gmsPath
	}

	@IBAction func prepare(_ sender: UIButton) {
		self.prepareForFlight()
	}


	@IBAction func upload(_ sender: UIButton) {
		self.uploadMission()
	}

	@IBAction func go(_ sender: UIButton) {
		self.startMission()
	}


	@IBAction func checkStatus(_ sender: UIButton) {
		self.checkOperatorState()
	}

	@IBAction func stop(_ sender: UIButton) {
		self.stopMission()
	}
	@IBAction func setHeight(_ sender: UIStepper) {
		self.height = sender.value
		self.heightLabel.text = String("Height: \(self.height)")
	}
	@IBAction func setUseServerHeight(_ sender: UISwitch) {
		self.useServerHeight = sender.isOn
	}

	@IBAction func setSpeed(_ sender: UIStepper) {
		self.speed = sender.value
		self.speedLabel.text = String("Speed: \(self.speed)")
	}

}

extension GoogleMapsViewController {

	// MARK: Execute

	@IBAction func postSearchArea(_ sender: UIButton) {
		self.resetPath()

		let homeLocation = CoordinateManager.manager.appLocation.coordinate
		let json: [String: Any] = ["coordinates": self.markers.map({ (marker) -> [String: Any] in
			return ["latitude": marker.position.latitude.rounded(toPlaces: 6), "longitude": marker.position.longitude.rounded(toPlaces: 6)]
		}), "height": self.height, "start": ["latitude": homeLocation.latitude, "longitude": homeLocation.longitude]]

		let jsonData = try? JSONSerialization.data(withJSONObject: json)

		let url = URL(string: "https://speepio.jowies.com/path")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")


		let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print(responseJSON)
			}
		}

		task.resume()
		self.downloadButton.isEnabled = true
	}


	@IBAction func downloadPath(_ sender: UIButton) {

		self.resetPath()

		let url = URL(string: "https://speepio.jowies.com/path")!
		var request = URLRequest(url: url)

		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {

				guard let path = responseJSON["path"] as? [[String: Any]] else {
					print("Path response has no property 'path'")
					return
				}

				guard let length = responseJSON["length"] as? Double else {
					print("Path property has no property length")
					return
				}
				var lastLocation: CLLocation? = nil

				path.forEach({ point in
					if let latitude = point["latitude"] as? Double, let longitude = point["longitude"] as? Double, let altitude = point["altitude"] as? Double {

						if lastLocation == nil {
							lastLocation = CLLocation(latitude: latitude, longitude: longitude)
							self.path.append(PathPoint(latitude: latitude, longitude: longitude, altitude: altitude))
						} else {
							let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
							if lastLocation!.distance(from: currentLocation) > 0.6 {
								self.path.append(PathPoint(latitude: latitude, longitude: longitude, altitude: altitude))
							}
							lastLocation = CLLocation(latitude: latitude, longitude: longitude)
						}

					}
					else {
						print("Error in Point: \(point)")
					}
				})


				self.footprintLength = length

				self.path.forEach({ (point: PathPoint) in
					let circle = GMSCircle(position: point.asCLLocation2D(), radius: 0.6)
					circle.fillColor = .red
					circle.map = self.mapView
					self.pathCircles.append(circle)
				})
				let polyline = GMSPolyline(path: self.getGMSPath())
				polyline.map = self.mapView
				self.pathPolyline = polyline
			}
			else {
				print("Error in JSON path response")
			}
		}

		task.resume()

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

	// MARK: Marker and polygon

	private func addMarker(at position: CLLocationCoordinate2D) {
		let newMarker = GMSMarker(position: position)
		newMarker.appearAnimation = .pop
		newMarker.map = self.mapView
		newMarker.isDraggable = true
		self.markers.append(newMarker)
	}

	private func updatePolygon() {

		// Get marker positions
		let polygonPath = GMSMutablePath()
		self.markers = self.markers.filter({ $0.map != nil })
		let markerPositions = self.markers.map({ $0.position })
		// let sortedPositions = sortConvex(input: markerPositions)
		markerPositions.forEach({ position in
			polygonPath.add(position)
		})

		// Init polygon and set up
		self.polygon.map = nil
		self.polygon = GMSPolygon(path: polygonPath)
		self.polygon.fillColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.3)
		self.polygon.strokeColor = .blue
		self.polygon.strokeWidth = 2

		self.polygon.map = self.mapView

		self.executeButton.isEnabled = self.markers.count >= 3
	}




}



extension GoogleMapsViewController {

	func checkOperatorState() {
		guard let missionOperator = self.missionOperator else {
			print("Mission operator not set")
			return
		}
		self.logOperatorState(missionOperator: missionOperator)
	}


	func logWaypointMissionState(missionState: DJIWaypointMissionState) {

		var status = "None"

		switch missionState {
		case .disconnected:
			status = "Disconnected"
		case .notSupported:
			status = "Not supported"
		case .readyToUpload:
			status = "Ready to upload"
		case .uploading:
			status = "Uploading"
		case .readyToExecute:
			status = "Ready to execute"
		case .executing:
			status = "Executing"
		case .executionPaused:
			status = "Executing paused"
		case .recovering:
			status = "Recovering"
		case .unknown:
			status = "Unknown"
		default:
			status = "None"
		}
		print(status)
		self.statusLabel.text = status
	}

	func logOperatorState(missionOperator: DJIWaypointMissionOperator) {
		self.logWaypointMissionState(missionState: missionOperator.currentState)
	}

	func prepareForFlight() {
		self.mission.removeAllWaypoints()

		self.mission.addWaypoints(self.path.map({ (point: PathPoint) -> DJIWaypoint in
			let wayPoint = DJIWaypoint(coordinate: point.asCLLocation2D())
			wayPoint.altitude = self.useServerHeight ? Float(point.altitude) : Float(self.height)
			wayPoint.shootPhotoDistanceInterval = Float(self.footprintLength)

			return wayPoint
		}))
		self.mission.autoFlightSpeed = Float(self.speed)
		self.mission.maxFlightSpeed = Float(self.speed)
		self.mission.finishedAction = .autoLand

		guard let missionOperator = self.missionOperator else {
			print("Mission operator not set...")
			return
		}

		if let error = mission.checkParameters() {
			print("Error in parameters: \(error)")
			return
		}

		if let error = missionOperator.load(self.mission) {
			print("Error in mission load: \(error)")
		}

		missionOperator.addListener(toUploadEvent: self, with: DispatchQueue.main, andBlock: { (event) in
			// self.logWaypointMissionState(missionState: event.currentState)
			if event.error != nil {
				print("Upload error: \(event.error!)")
			}
		})

		self.logOperatorState(missionOperator: missionOperator)
	}

	func uploadMission() {
		guard let missionOperator = self.missionOperator else {
			print("Mission operator not set!")
			return
		}

		guard (missionOperator.loadedMission != nil) else {
			print("Mission not loaded!")
			return
		}

		missionOperator.uploadMission(completion: { (err) in
			if err != nil {
				print("Error when uploading mission: \(err!)")
				return
			}
			print("Uploading complete!!! Start your flight.")
		})
		self.logOperatorState(missionOperator: missionOperator)
	}

	func startMission() {
		guard let missionOperator = self.missionOperator else {
			print("Mission operator not set!")
			return
		}
		missionOperator.startMission(completion: { (err) in
			if err != nil {
				print("Error when starting mission: \(err!)")
				return
			}
			self.logOperatorState(missionOperator: missionOperator)
			print("Mission started!!!")
		})
		self.logOperatorState(missionOperator: missionOperator)
	}

	func stopMission() {
		guard let missionOperator = self.missionOperator else {
			print("Mission operator not set!")
			return
		}

		missionOperator.stopMission(completion: { (err) in
			if err != nil {
				print("Error when stopping mission: \(err!)")
				print(err!.localizedDescription)
				return
			}
			print("Mission stopping!")
		})
	}

}
