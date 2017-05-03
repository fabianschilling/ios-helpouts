//
//  HelpoutsTabBarController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/20/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CloudKit

class HelpoutsTabBarController: UITabBarController {
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(HelpoutsTabBarController.receivedHelpoutNotification(_:)), name: NSNotification.Name(rawValue: Constants.NSNotifications.ReceivedHelpoutNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HelpoutsTabBarController.receivedMessageNotification(_:)), name: NSNotification.Name(rawValue: Constants.NSNotifications.ReceivedMessageNotification), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    
    func receivedHelpoutNotification(_ notification: Notification) {
        Log.log("Received helpout notification.")
        performSegue(withIdentifier: Constants.Segues.IncomingSegue, sender: self)
    }
    
    func receivedMessageNotification(_ notification: Notification) {
        Log.log("Received message notification.")
        //incrementHelpoutsBadgeCount()
    }
    
    // MARK: - TabBar badge
    
    func incrementHelpoutsBadgeCount() {
        let badgeIcon = viewControllers![1].tabBarItem!
        if let badgecount = badgeIcon.badgeValue?.toInt() {
            badgeIcon.badgeValue = "\(badgecount + 1)"
        } else {
            badgeIcon.badgeValue = "1"
        }
    }
    
    func resetHelpoutsBadgeCount() {
        viewControllers![1].tabBarItem!.badgeValue = nil
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.IncomingSegue {
            if let incomingViewController = segue.destinationViewController.topViewController as? IncomingTableViewController {
                
                // prepare for incoming segue
            }
        }
    }
}
