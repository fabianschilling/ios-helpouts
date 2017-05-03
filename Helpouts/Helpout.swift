//
//  Helpout.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/13/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Helpout: PFObject, PFSubclassing {
    
    
    static let ClassName = "Helpout"
    
    struct Keys {
        
        static let message = "message"
        static let creator = "creator"
        static let helper = "helper"
        static let users = "users"
        static let receivers = "receivers"
        static let status = "status"
        static let geoPoint = "geoPoint"
        static let timestamp = "timestamp"
    }
    
    static func parseClassName() -> String {
        return ClassName
    }
    
    @NSManaged var message: String
    @NSManaged var creator: PFUser
    @NSManaged var helper: PFUser?
    @NSManaged var users: [PFUser]
    @NSManaged var receivers: [PFUser]
    @NSManaged var status: String
    @NSManaged var geoPoint: PFGeoPoint
    @NSManaged var timestamp: Date
    

    override init() {
        super.init()
    }
    
    /*
    override var description: String {
        return "\(creator.firstName): \(message) (receivers: \(receivers), helpers: \(users), status: \(status)"
    }
    */
}
