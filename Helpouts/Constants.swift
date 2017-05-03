//
//  Constants.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/14/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: - Facebook
    
    struct FacebookPermissions {
        
        static let Email = "email"
        static let PublicProfile = "public_profile"
        static let UserFriends = "user_friends"
        
    }
    
    // MARK: - Parse
    
    static let RadiusInKilometers = 3.0

    // MARK: - Segues
    
    struct Segues {
        
        static let DetailSegue = "DetailSegue"
        static let IncomingSegue = "IncomingSegue"
        static let MapSegue = "MapSegue"
        static let MessagesSegue = "MessagesSegue"
        static let ModelSegue = "ModelSegue"
        static let OutgoingSegue = "OutgoingSegue"
        static let ProfileSegue = "ProfileSegue"
        static let SelectHelperSegue = "SelectHelperSegue"
        static let SignupSegue = "SignupSegue"
        static let UnwindToDetail = "UnwindToDetail"
        static let UnwindToHelpouts = "UnwindToHelpouts"
        static let UnwindToLogin = "UnwindToLogin"
        static let UnwindToProfile = "UnwindToProfile"
        
    }
    
    // MARK: Notifications
    
    static let Action = "action"
    static let Alert = "alert"
    static let Object = "object"
    
    struct Actions {
        static let Message = "message"
        static let HelpoutCreated = "helpout-created"
        static let HelpoutDeleted = "helpout-deleted"
        static let HelpoutUpdated = "helpout-updated"
        static let HelpoutAccepted = "helpout-accepted"
        static let HelpoutUnsubscribed = "helpout-unsubscribed"
    }
    
    struct Status {
        static let Active = "Active"
        static let Helped = "Helped"
        static let Deleted = "Deleted"
    }
    
    struct NSNotifications {
        
        // posted when location updated
        static let DidUpdateLocations = "DidUpdateLocations"
        // posted when a helper is added to the helpout
        static let HelpersChangedNotification = "HelpersChangedNotification"
        // posten when the user accepts an incoming helpout
        static let HelpoutAcceptedNotification = "HelpoutAcceptedNotification"
        // posted when receiving an external helpout as a receiver
        static let ReceivedHelpoutNotification = "ReceivedHelpoutNotification"
        // posted when a new message is received
        static let ReceivedMessageNotification = "ReceivedMessageNotification"
        
    }
    
    // MARK: - Images
    
    struct Images {
        
        static let DefaultProfileImage = "DefaultProfileImage"
        
    }
    
    // MARK: - Directories
    
    struct Directories {
        
        static let Images = "Images"
        
    }
    
    // MARK: - TableView Cell Identifier
    
    struct Identifiers {
        
        static let IncomingLocation = "IncomingLocation"
        static let IncomingMessage = "IncomingMessage"
        static let OutgoingLocation = "OutgoingLocation"
        static let OutgoingMessage = "OutgoingMessage"
        static let ReceivedHelpout = "ReceivedHelpout"
        static let SentHelpout = "SentHelpout"
        
    }
    
}