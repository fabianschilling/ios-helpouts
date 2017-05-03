//
//  PFGeoPointExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/15/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension PFGeoPoint {
    
    var location: CLLocation? {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
}