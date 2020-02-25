//
//  CoordinateManager.swift
//  SheepFinder
//
//  Created by Jowie on 29/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK
import CoreLocation

class CoordinateManager: NSObject, CLLocationManagerDelegate {
    
    static let manager = CoordinateManager()
    
    var locationManager: CLLocationManager!
    
    var appLocation: CLLocation = CLLocation()
    var flightController: DJIFlightController? = nil

    private override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            NSLog("Location good")
            
        }
        self.flightController = DJIFlightController()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.appLocation = locations.last! as CLLocation
    }
    
    func getAppLocationAs2D() -> CLLocationCoordinate2D {
        return convertTo2DCoordinate(location: self.appLocation)
    }
    
    func setHomeLocation(location: CLLocation? = nil) {
        let loc = location ?? self.appLocation
        self.flightController?.setHomeLocation(loc, withCompletion: nil);
    }
    
    func convertTo2DCoordinate(location: CLLocation) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
