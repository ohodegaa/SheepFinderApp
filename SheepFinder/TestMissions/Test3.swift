//
//  Test3.swift
//  SheepFinder
//
//  Created by Jonathan on 04/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//


import DJISDK

class Test3: TestMission {
    var addActions: [DJIMissionAction] = [
        DJITakeOffAction(),
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406780, longitude: 63.418988), altitude: 5)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406200, longitude: 63.419276), altitude: 5)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406780, longitude: 63.418988), altitude: 5)!,
        DJILandAction(),
    ];
    
    override init() {
        super.init()
        self.actions = addActions;
    };
}
