//
//  NotificationManager.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/28/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation
import CloudKit

class NotificationManager {
    
    // MARK: Class variables
    
    static let sharedInstance = NotificationManager()
    let notificationCenter = NotificationCenter.default
    
    // MARK: Designated Initializer
    
    init() {
        // initialize stuff
    }
    
    // MARK: Remote notifications
    
    /*
    func handleMessageCreatedNotification(notification: CKQueryNotification, message: Message) {
        
        Log.log("Handling message created notification.")
        
        notificationCenter.postNotificationName(Constants.NSNotifications.ReceivedMessageNotification, object: nil)
    }
    
    func handleHelpoutCreatorUpdatedNotification(notification: CKQueryNotification, helpoutRecord: CKRecord) {
        
        Log.log("Handling helpout creator updated notification.")
        
        let helpout = Helpout.updateHelpout(helpoutRecord)
        
        notificationCenter.postNotificationName(Constants.NSNotifications.HelpersChangedNotification, object: nil)
        
        Alert.showAlert("Congratulations", message: "Your helpout \"\(helpout.text)\" has a new helper!")
        
    }
    
    func handleHelpoutReceiversCreatedNotification(notification: CKQueryNotification, helpoutRecord: CKRecord, creatorRecord: CKRecord) {
        
        Log.log("Handling helpout receivers created notification.")
        
        helpoutRecords.append(helpoutRecord)
        creatorRecords.append(creatorRecord)
        
        notificationCenter.postNotificationName(Constants.NSNotifications.ReceivedHelpoutNotification, object: nil)
    }
    
    func handleHelpoutHelpersUpdatedNotification(notification: CKQueryNotification) {

        let recordFields = notification.recordFields

        let helpoutCreatorID = recordFields[Constants.Keys.Creator] as! String
        
        let creator = User.fetchUser(helpoutCreatorID, attributeName: Constants.Attributes.Record)!
        let helpout = Helpout.fetchHelpout(notification.recordID.recordName, attributeName: Constants.Attributes.Record)!
        
        if let helpoutHelperID = recordFields[Constants.Keys.Helper] as? String {
            
            helpout.status = Constants.Status.Helped
            helpout.managedObjectContext?.save(nil)
            
            if helpoutHelperID == User.currentUser().record {
                Alert.showAlert("Congratulations", message: "\(creator.name) marked you as the helper of \"\(helpout.text)\". Thanks for your engagement.")
            } else {
                Alert.showAlert("Helpout Closed", message: "\(creator.name) closed \"\(helpout.text)\". Thanks for your engagement.")
            }
        }
    }
    
    func handleHelpoutHelpersDeletedNotification(notification: CKQueryNotification) {
        
        let recordFields = notification.recordFields
        
        let helpoutCreatorID = recordFields[Constants.Keys.Creator] as! String
        
        let helpout = Helpout.fetchHelpout(notification.recordID.recordName, attributeName: Constants.Attributes.Record)!
        let creator = User.fetchUser(helpoutCreatorID, attributeName: Constants.Attributes.Record)!
        helpout.status = Constants.Status.Deleted
        helpout.managedObjectContext?.save(nil)
        Alert.showAlert("Helpout Deleted", message: "\(creator.name) deleted the helpout \"\(helpout.text)\". We are sorry if you were still trying to help.")
        Helpout.deleteHelpout(helpout)
    }
    */
}
