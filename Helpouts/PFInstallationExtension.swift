//
//  PFInstallationExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/15/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension PFInstallation {
    
    struct Keys {
        static let user = "user"
    }
    
    var user: PFUser? {
        get {
            return self.objectForKey(Keys.user) as? PFUser
        }
        set {
            if let value = newValue {
                self.setObject(value, forKey: Keys.user)
                Log.log("Set \(value.firstName!) as user for this installation.")
            } else {
                Log.log("Trying to set user to nil.")
            }
        }
    }
}