//
//  HelpoutsTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/13/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class HelpoutsTableViewController: PFQueryTableViewController {

    let ReuseIdentifier = "HelpoutCell"
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: "handleHelpoutNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutCreated), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleHelpoutNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutDeleted), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleHelpoutNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutAccepted), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleHelpoutNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleHelpoutNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutUnsubscribed), object: nil)
        tableView.tableFooterView = UIView(frame: CGRect.zero) // hide empty cells!
    }
    
    // MARK: - Notifications
    
    func handleHelpoutNotification(_ notification: Notification) {
        self.loadObjects()
    }
    
    // MARK: - PFQueryTableViewDataSource
    
    override func queryForTable() -> PFQuery {
        
        let creatorQuery = Helpout.query()!
        creatorQuery.whereKey(Helpout.Keys.creator, equalTo: PFUser.currentUser()!)
        
        let userQuery = Helpout.query()!
        userQuery.whereKey(Helpout.Keys.users, containsAllObjectsInArray: [PFUser.currentUser()!])
        
        let compoundQuery = PFQuery.orQueryWithSubqueries([creatorQuery, userQuery])
        compoundQuery.orderByDescending(Helpout.Keys.timestamp)
        
        compoundQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        return compoundQuery
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects!.count > 0 {
            tableView.backgroundView = nil
        } else {
            tableView.backgroundView = UILabel.backgroundForTableView(tableView, withText: "Tap + to create a helpout.")
        }
        return objects!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! HelpoutTableViewCell
        let helpout = object as! Helpout
        
        cell.helpoutTextLabel.text = helpout.message
        cell.timeLabel.text = helpout.timestamp.humanReadable
        
        helpout.creator.fetchIfNeededInBackgroundWithBlock { (object, error) in
            if object != nil && error == nil {
                let creator = object as! PFUser
                cell.nameLabel.text = creator.firstName
                
                creator.imageFile?.getDataInBackgroundWithBlock() { (data, error)  in
                    if data != nil && error == nil {
                        let image = UIImage(data: data!)
                        cell.imageButton.image = image
                    }
                }

            }
        }
        
        return cell
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegueWithIdentifier(Constants.Segues.DetailSegue, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
        /*
        let helpout = self.objectAtIndexPath(indexPath) as! Helpout
        if helpout.creator.objectId == PFUser.currentUser()?.objectId {
            return true
        } else {
            return false
        }
        */
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: IndexPath) -> String! {
        let helpout = self.objectAtIndexPath(indexPath) as! Helpout
        if helpout.creator.objectId == PFUser.currentUser()?.objectId {
            return "Delete"
        } else {
            return "Unsubscribe"
        }
    }
    
    override func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Deletion buggy
            
            let helpout = self.objectAtIndexPath(indexPath) as! Helpout
            
            
            if helpout.creator.objectId == PFUser.currentUser()?.objectId { // Delete Helpout
                
                helpout.deleteInBackgroundWithBlock(){ (success, error) in
                    if success && error == nil {
                        Log.log("Helpout deleted.")
                        
                        self.loadObjects()
                        
                        // Push notification
                        let pushQuery = PFInstallation.query()!
                        pushQuery.whereKey(PFInstallation.Keys.user, containedIn: helpout.users)
                        
                        let push = PFPush()
                        push.setQuery(pushQuery)
                        push.setData([Constants.Alert: "\(PFUser.currentUser()!.firstName!) deleted a helpout: \(helpout.message)", Constants.Action: Constants.Actions.HelpoutDeleted, Constants.Object: helpout.objectId!])
                        
                        push.sendPushInBackgroundWithBlock { (success, error) in
                            if success && error == nil {
                                Log.log("Helpout deleted push notification sent.")
                            }
                        }
                    }
                }
            } else { // Remove myself from users
                
                var newUsers: [PFUser] = []
                for user in helpout.users {
                    if user.objectId != PFUser.currentUser()?.objectId {
                        newUsers.append(user)
                    }
                }
                
                helpout.users = newUsers
                
                helpout.saveInBackgroundWithBlock { (success, error) in
                    if success && error == nil {
                        Log.log("Removed myself from users")
                        
                        self.loadObjects()
                        
                        // Push notification
                        let pushQuery = PFInstallation.query()!
                        pushQuery.whereKey(PFInstallation.Keys.user, equalTo: helpout.creator)
                        
                        let push = PFPush()
                        push.setQuery(pushQuery)
                        push.setData([Constants.Alert: "\(PFUser.currentUser()!.firstName!) unsubscribed from your helpout: \(helpout.message)", Constants.Action: Constants.Actions.HelpoutUnsubscribed])
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.DetailSegue {
            if let detailViewController = segue.destination as? DetailTableViewController {
                let indexPath = sender as! IndexPath
                let helpout = objectAtIndexPath(indexPath) as! Helpout
                detailViewController.helpout = helpout
            }
        }
    }

}
