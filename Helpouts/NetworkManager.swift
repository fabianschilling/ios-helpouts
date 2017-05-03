//
//  NetworkManager.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/28/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    // MARK: Class variables
    
    static let sharedInstance = NetworkManager()
    let application = UIApplication.sharedApplication()
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate
    let reachability = Reachability.reachabilityForInternetConnection()
    var tasks: Int
    
    // MARK: Designated initializer
    
    override init() {
        self.tasks = 0
        super.init()
        setupReachability()
    }
    
    // MARK: Netword Activity
    
    func startNetworkActivity() -> Bool {
        
        if !reachability.isReachable() {
            Alert.showAlert(Alert.Internet.Title, message: Alert.Internet.Message)
            return false
        }
        
        if !application.networkActivityIndicatorVisible {
            application.networkActivityIndicatorVisible = true
        }
        
        tasks += 1
        
        return true
    }
    
    func stopNetworkActivity() {
        
        tasks -= 1
        
        if tasks <= 0 {
            application.networkActivityIndicatorVisible = false
            tasks = 0
        }
    }
    
    // MARK: - Reachability
    
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkManager.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil)
        reachability.startNotifier()
    }
    
    func reachabilityChanged(_ notification: Notification) {
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                Log.log("Reachable via WiFi")
            } else {
                Log.log("Reachable via Cellular")
            }
        } else {
            Log.log("Not reachable")
        }
    }
}
