//
//  LocationManager.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/7/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Class Variables
    
    static let sharedInstance = LocationManager()
    var manager: CLLocationManager
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    
    // MARK: - Designated Initializer
    
    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(LocationManager.updateLocation), userInfo: nil, repeats: true)
    }
    
    // MARK: - Locations
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    // MARK: - LocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager!, didChangeAuthorization status: CLAuthorizationStatus) {
        Log.log("Did change authorization status.")
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            Log.log("Location authorization status not determined.")
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            Log.log("Location authorization status always. Sweet!")
        case .authorizedWhenInUse:
            Log.log("Location authorization status when in use.")
            manager.requestAlwaysAuthorization()
        case .denied:
            Log.log("Location authorization status denied.")
        case .restricted:
            Log.log("Location authorization status restricted. Not much I can do...")
        }
    }
    
    func locationManager(_ manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        currentLocation = newLocation
        //Log.log("Location updated locally.")
        manager.stopUpdatingLocation()
        // FIX: uncomment if you want cloud location updates
        //updateCloudLocation()
    }
    
    // MARK: - Cloud updates
    
    func updateCloudLocation() {
        let user = PFUser.currentUser()
        user?.geoPoint = PFGeoPoint(location: currentLocation)
        user?.saveInBackgroundWithBlock() { (success, error) in
            if success {
                Log.log("Location updated in the cloud")
            } else {
                Log.log(error!.localizedDescription)
            }
        }
    }
}
