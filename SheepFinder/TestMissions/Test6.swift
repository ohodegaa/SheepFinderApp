//
//  Test6.swift
//  SheepFinder
//
//  Created by Jonathan on 04/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK


class Test6: TestMission {
    var addActions: [DJIMissionAction] = [
        DJITakeOffAction(),
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406780, longitude: 63.418988), altitude: 20)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406425, longitude: 63.419033), altitude: 20)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406366, longitude: 63.419214), altitude: 20)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406823, longitude: 63.419242), altitude: 20)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406780, longitude: 63.418988), altitude: 20)!,
        DJILandAction(),
    ];
    
    override init() {
        super.init()
        self.actions = addActions;
    };
}
