//
//  Thread.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/16/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Queue {
    class var MainQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    // Tasks that need to be done immediately in order to provide a nice user experience
    class var UserInteractiveQueue: DispatchQueue {
        return dispatch_get_global_queue(Int(DispatchQoS.QoSClass.userInteractive.value), 0)
    }
    
    // Tasks that are initiated from the UI and can be performed asynchronousy
    class var GlobalUserInitiatedQueue: DispatchQueue {
        return dispatch_get_global_queue(Int(DispatchQoS.QoSClass.userInitiated.value), 0)
    }
    
    // Tasks that are long-running, typically with a user-visible progress indicator
    class var GlobalUtilityQueue: DispatchQueue {
        return dispatch_get_global_queue(Int(DispatchQoS.QoSClass.utility.value), 0)
    }
    
    // Tasks that the user is not directly aware of
    class var GlobalBackgroundQueue: DispatchQueue {
        return dispatch_get_global_queue(Int(DispatchQoS.QoSClass.background.value), 0)
    }
}

