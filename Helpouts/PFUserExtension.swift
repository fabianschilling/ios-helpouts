//
//  PFUserExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/13/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension PFUser {
    
    struct Keys {
        static let firstName = "firstName"
        static let imageFile = "imageFile"
        static let geoPoint = "geoPoint"
        static let timestamp = "timestamp"
    }
    
    // MARK: Required variables
    
    var firstName: String? {
        get {
            return self.objectForKey(Keys.firstName) as? String
        }
        set {
            if let value = newValue {
                self.setObject(value, forKey: Keys.firstName)
            } else {
                Log.log("Trying to set firstName to nil.")
            }
        }
    }
    
    var imageFile: PFFile? {
        get {
            return self.objectForKey(Keys.imageFile) as? PFFile
        }
        set {
            if let value = newValue {
                self.setObject(newValue!, forKey: Keys.imageFile)
            } else {
                Log.log("Trying to set imageFile to nil.")
            }
        }
    }
    
    var geoPoint: PFGeoPoint? {
        get {
            return self.objectForKey(Keys.geoPoint) as? PFGeoPoint
        }
        set {
            if let value = newValue {
                self.setObject(newValue!, forKey: Keys.geoPoint)
            } else {
                Log.log("Trying to set geoPoint to nil.")
            }
        }
    }
    
    var timestamp: NSDate? {
        get {
            return self.objectForKey(Keys.timestamp) as? NSDate
        }
        set {
            if let value = newValue {
                self.setObject(value, forKey: Keys.timestamp)
            } else {
                Log.log("Trying to set timestamp to nil.")
            }
        }
    }
    
    // MARK: Convenience getters
    
    var location: CLLocation? {
        get {
            return geoPoint?.location
        }
    }
    
    /*
    public override var description: String {
        if let name = self.firstName {
            return name
        } else {
            return "First name not set"
        }
    }
    */
    
}