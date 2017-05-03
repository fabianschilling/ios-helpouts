//
//  Message.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/13/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Message: PFObject, PFSubclassing {
    
    static let ClassName = "Message"
    
    struct Keys {
        static let message = "message"
        static let helpout = "helpout"
        static let geoPoint = "geoPoint"
        static let receiver = "receiver"
        static let sender = "sender"
        static let timestamp = "timestamp"
    }
    
    class func parseClassName() -> String {
        return ClassName
    }
    
    @NSManaged var message: String
    @NSManaged var helpout: Helpout
    @NSManaged var geoPoint: PFGeoPoint?
    @NSManaged var receiver: PFUser
    @NSManaged var sender: PFUser
    @NSManaged var timestamp: Date
    
    override init() {
        super.init()
    }
    
    /*
    override var description: String {
        return "\(sender.firstName) -> \(receiver.firstName): \(message)"
    }
    */

}
