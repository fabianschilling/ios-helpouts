//
//  IncomingTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/20/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

class IncomingTableViewController: UITableViewController {
    
    // MARK: - Class variables
    
    var helpout: Helpout!
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageButton: CircleButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var helpoutLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var acceptButton: CircleButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func acceptButtonTapped() {
        
        if helpout.users.isEmpty {
            helpout.users = [PFUser.currentUser()!]
        } else if contains(helpout.users, PFUser.currentUser()!) {
            Alert.showAlert("Helpouts Error", message: "You already accepted this helpout.")
            return
        } else {
            helpout.users.append(PFUser.currentUser()!)
        }
        
        startRefreshing()
        
        helpout.saveInBackgroundWithBlock { (success, error) in
            
            self.stopRefreshing()
            
            if success && error == nil {
                
                Log.log("Helpout updated with myself as a user.")
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Actions.HelpoutAccepted, object: nil)
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                
                
                // Push notification
                let pushQuery = PFInstallation.query()!
                pushQuery.whereKey(PFInstallation.Keys.user, equalTo: self.helpout.creator)
                
                let push = PFPush()
                push.setQuery(pushQuery)
                
                push.setData([Constants.Alert: "Your helpout \(self.helpout.message) was accepted by \(PFUser.currentUser()!.firstName!). Congratulations!", Constants.Action: Constants.Actions.HelpoutUpdated])
                
                push.sendPushInBackgroundWithBlock { (success, error) in
                    if success && error == nil {
                        Log.log("Helpout updated push notification sent.")
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Refreshing
    
    func startRefreshing() {
        view.isUserInteractionEnabled = false
        spinner.startAnimating()
        acceptButton.setTitle("", for: UIControlState())
        
    }
    
    func stopRefreshing() {
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        acceptButton.setTitle("Accept", for: UIControlState())
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
    }
    
    // MARK: - View Setup
    
    func setupOutlets() {
        
        // TODO: setup outlets
        helpoutLabel.text = helpout.message
        
        helpout.creator.fetchIfNeededInBackgroundWithBlock { (object, error) in
            if object != nil && error == nil {
                let creator = object as! PFUser
                
                self.nameLabel.text = creator.firstName
                
                let distanceInMeters = Int(creator.geoPoint!.distanceInKilometersTo(PFUser.currentUser()!.geoPoint) / 1000)
                
                self.distanceLabel.text = "\(distanceInMeters) meters away."
                
                creator.imageFile?.getDataInBackgroundWithBlock { (data, error) in
                    if data != nil && error == nil {
                        let image = UIImage(data: data!)
                        self.profileImageButton.image = image
                    }
                }
            }
        }
        
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
