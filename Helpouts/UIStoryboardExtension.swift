//
//  UIStoryboardExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/7/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class var mainViewController: HelpoutsTabBarController {
        get {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! HelpoutsTabBarController
        }
    }
    
    class var loginViewController: LoginTableViewController {
        get {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginTableViewController
        }
    }
    
    class var incomingViewController: UINavigationController {
        get {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Incoming") as! UINavigationController
        }
    }
}
