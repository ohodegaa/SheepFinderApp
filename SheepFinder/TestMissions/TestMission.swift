//
//  TestMission.swift
//  SheepFinder
//
//  Created by Jonathan on 03/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK

class TestMission {
    
    var actions: [DJIMissionAction]  = []
    
    public func scheduleMission(control: DJIMissionControl?) {
        for action in actions {
            control?.scheduleElement(action);
        }
    }
}
