//
//  Test5.swift
//  SheepFinder
//
//  Created by Jonathan on 04/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//


import DJISDK

class Test5: TestMission {
    var addActions: [DJIMissionAction] = [
        DJITakeOffAction(),
        DJIGoToAction(coordinate: CoordinateManager.manager.convertTo2DCoordinate(location: CoordinateManager.manager.homeLocation), altitude: 10)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406369, longitude: 63.419212), altitude: 10)!,
        DJIGoToAction(coordinate: CLLocationCoordinate2D(latitude: 10.406156, longitude: 63.419297), altitude: 10)!,
        DJIGoToAction(coordinate: CoordinateManager.manager.convertTo2DCoordinate(location: CoordinateManager.manager.homeLocation), altitude: 10)!,
        DJILandAction(),
    ];
    
    override init() {
        super.init()
        self.actions = addActions;
    };
}
