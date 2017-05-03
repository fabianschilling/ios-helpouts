//
//  AroundMeTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/4/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class AroundMeTableViewController: PFQueryTableViewController {
    
    // MARK: Class Variables
    
    let ReuseIdentifier = "HelpoutCell"
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: "helpoutAcceptedNotification:", name: NSNotification.Name(rawValue: Constants.Actions.HelpoutAccepted), object: nil)
        tableView.tableFooterView = UIView(frame: CGRect.zero) // hide empty cells!
    }
    
    // MARK: - Notification Center
    
    func helpoutAcceptedNotification(_ notification: Notification) {
        loadObjects()
    }
    
    // MARK: - PFQueryTableViewDataSource
    
    override func queryForTable() -> PFQuery {
        
        let user = PFUser.currentUser()!
        let query = Helpout.query()!
        
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        query.whereKey(Helpout.Keys.creator, notEqualTo: user)
        query.whereKey(Helpout.Keys.users, notEqualTo: user)
        query.whereKey(Helpout.Keys.status, equalTo: Constants.Status.Active)
        
        //query.whereKey(Helpout.Keys.geoPoint, nearGeoPoint: user.geoPoint!, withinKilometers: 3.0)
        query.orderByDescending(Helpout.Keys.timestamp)
        
        return query
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects!.count > 0 {
            tableView.backgroundView = nil
        } else {
            tableView.backgroundView = UILabel.backgroundForTableView(tableView, withText: "Pull to fetch nearby helpouts.")
        }
        
        return objects!.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Accept"){ (action, indexPath) in
            
            let helpout = self.objectAtIndexPath(indexPath) as! Helpout
            
            if helpout.users.isEmpty {
                helpout.users = [PFUser.currentUser()!]
            } else if contains(helpout.users, PFUser.currentUser()!) {
                Alert.showAlert("Helpouts Error", message: "You already accepted this helpout.")
                return
            } else {
                helpout.users.append(PFUser.currentUser()!)
            }
            
            helpout.saveInBackgroundWithBlock { (success, error) in
                
                if success && error == nil {
                    
                    Log.log("Helpout updated with myself as a user.")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Actions.HelpoutAccepted, object: nil)
                    
                    // Push notification
                    let pushQuery = PFInstallation.query()!
                    pushQuery.whereKey(PFInstallation.Keys.user, equalTo: helpout.creator)
                    
                    let push = PFPush()
                    push.setQuery(pushQuery)
                    
                    push.setData([Constants.Alert: "Your helpout \(helpout.message) was accepted by \(PFUser.currentUser()!.firstName!). Congratulations!", Constants.Action: Constants.Actions.HelpoutUpdated])
                    
                    push.sendPushInBackgroundWithBlock { (success, error) in
                        if success && error == nil {
                            Log.log("Helpout updated push notification sent.")
                        }
                    }
                }
            }
        }
        action.backgroundColor = UIColor.helpoutsColor
        return [action]
    }
    
    override func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        // do something
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let helpout = objectAtIndexPath(indexPath) as! Helpout
        performSegueWithIdentifier(Constants.Segues.IncomingSegue, sender: helpout)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.IncomingSegue {
            if let incomingViewController = segue.destination as? IncomingTableViewController {
                let helpout = sender as! Helpout
                incomingViewController.helpout = helpout
                incomingViewController.navigationItem.rightBarButtonItem = nil
            }
        }
    }

}
