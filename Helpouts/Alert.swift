//
//  Alert.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/16/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Alert: NSObject{
    
    override init() {
        super.init()
    }
    
    struct Internet {
        static let Title = "No Internet Connection"
        static let Message = "Please check your Internet connection and try again"
    }
    
    struct Email {
        static let Title = "Invalid email"
        static let Message = "The email you entered is invalid. Please enter a valid one."
    }
    
    struct Password {
        static let Title = "Invalid password"
        static let Message = "The password you entered is invalid. It must have at least eight characters."
    }
    
    struct Name {
        static let Title = "Invalid name"
        static let Message = "The name you entered does not seem to be valid. Please enter your first name."
    }
    
    struct PasswordMatch {
        static let Title = "Passwords don't match"
        static let Message = "The passwords you entered don't match."
    }
    
    struct Signup {
        static let Title = "Signup failed"
        static let Message = "The email you entered has already been taken. Please choose another one."
    }
    
    struct Login {
        static let Title = "Login failed"
        static let Message = "The email and password combination does not match our records. Did you forget your password?"
    }
    
    static var backgroundLocationAccessAlert: UIAlertController {
        let alertController = UIAlertController(title: "Background Location Access", message: "In order to be notified when a person around you needs help, please open Helpout's settings and set location access to 'Always'.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil) // Add a handler to this!
        alertController.addAction(cancelAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { action in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        return alertController
    }
    
    static func showAlert(_ title: String, message: String) {
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.alertViewStyle = .Default
        alertView.show()
    }
    
}

