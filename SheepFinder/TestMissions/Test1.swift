//
//  Test1.swift
//  SheepFinder
//
//  Created by Jonathan on 04/03/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import DJISDK

class Test1: TestMission {
    var addActions: [DJIMissionAction] = [
        DJITakeOffAction(),
        DJILandAction(),
    ];
    
    override init() {
        super.init()
        self.actions = addActions;
    };
}
