//
//  OutgoingTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/20/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit

class OutgoingTableViewController: UITableViewController, UITextFieldDelegate {
    
    var receivers: [PFUser]! {
        didSet {
            receiverCount = receivers.count
        }
    }
    
    struct Status {
        static let Looking = "Looking for helpers around you..."
        static let Sending = "Sending..."
    }
    
    var saveButtonEnabled: Bool = false {
        didSet {
            saveButton.isEnabled = saveButtonEnabled
        }
    }
    
    var characterCount: Int = 0 {
        didSet {
            saveButtonEnabled = (characterCount > 0 && receiverCount > 0)
        }
    }
    
    var receiverCount: Int = -1 {
        didSet {
            if receiverCount < 0 {
                statusLabel.text = Status.Looking
            } else if receiverCount == 0 {
                statusLabel.text = "No users close to you."
            } else if receiverCount == 1 {
                statusLabel.text = "1 user close to you."
            } else {
                statusLabel.text = "\(receiverCount) user close to you."
            }
            saveButtonEnabled = (characterCount > 0 && receiverCount > 0)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var helpoutTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        helpoutTextField.resignFirstResponder()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        spinner.startAnimating()
        statusLabel.text = Status.Sending
        let message = helpoutTextField.text
        
        var helpout = Helpout()
        helpout.creator = PFUser.currentUser()!
        helpout.geoPoint = PFUser.currentUser()!.geoPoint!
        helpout.receivers = receivers
        helpout.users = []
        helpout.status = "Active"
        helpout.message = message!
        helpout.timestamp = Date()
        
        helpout.saveInBackgroundWithBlock(){ (success, error) in
            
            self.spinner.stopAnimating()
            
            if error == nil && success {
                Log.log("Helpout saved in the cloud.")
                self.helpoutTextField.resignFirstResponder()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                
                // Push notification
                let pushQuery = PFInstallation.query()!
                pushQuery.whereKey(PFInstallation.Keys.user, containedIn: self.receivers)
                
                let push = PFPush()
                push.setQuery(pushQuery)
                push.setData([Constants.Alert: "\(PFUser.currentUser()!.firstName!) created a new helpout: \(helpout.message)", Constants.Action: Constants.Actions.HelpoutCreated])
                
                push.sendPushInBackgroundWithBlock { (success, error) in
                    if success && error == nil {
                        Log.log("Helpout created push notification sent.")
                    }
                }
                
                // Send local notification
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Actions.HelpoutCreated, object: nil)
                
            } else {
                Log.log(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        helpoutTextField.becomeFirstResponder()
        let location = LocationManager.sharedInstance.currentLocation
        
        var query = PFUser.query()!
        query.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        query.whereKey(PFUser.Keys.geoPoint, nearGeoPoint: PFUser.currentUser()!.geoPoint!, withinKilometers: Constants.RadiusInKilometers)
        
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        query.findObjectsInBackgroundWithBlock() { (results, error) in
            
            self.spinner.stopAnimating()
            
            if error == nil && results != nil {
                let users = results as! [PFUser]
                self.receivers = users
            } else {
                Log.log(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text as NSString
        let newText = text.stringByReplacingCharactersInRange(range, withString: string)
        characterCount = count(newText)
        return true
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil // makes Tableview nonselectable
    }

}
