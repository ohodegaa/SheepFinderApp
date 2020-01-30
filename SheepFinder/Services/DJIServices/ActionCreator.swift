//
//  ActionCreator.swift
//  SheepFinder
//
//  Created by Jowie on 29/01/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK

class ActionCreator: DJIGoToAction {
    init(lat: Double, long: Double) {
        super.init(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), altitude: CLLocationDistance(5))!
    }
}
