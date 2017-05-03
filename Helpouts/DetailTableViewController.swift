//
//  DetailTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/21/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    // MARK: Class variables
    
    let HeaderCell = "HeaderCell"
    let UserCell = "UserCell"
    let FooterCell = "FooterCell"
    let HeaderHeight: CGFloat = 216
    let FooterHeight: CGFloat = 80
    
    var helpout: Helpout!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailTableViewController.handleMessageNotification(_:)), name: NSNotification.Name(rawValue: Constants.Actions.Message), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailTableViewController.handleHelpoutUpdatedNotification(_:)), name: NSNotification.Name(rawValue: Constants.Actions.HelpoutUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailTableViewController.handleHelpoutUpdatedNotification(_:)), name: NSNotification.Name(rawValue: Constants.Actions.HelpoutUnsubscribed), object: nil)
        tableView.tableFooterView = UIView(frame: CGRect.zero) // hide empty cells!
    }
    
    // MARK: - Notification Center
    
    func handleMessageNotification(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func handleHelpoutUpdatedNotification(_ notification: Notification) {
        helpout.fetchInBackgroundWithBlock { (object, error) -> Void in
            if object != nil && error == nil {
                self.helpout = object as! Helpout
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderCell) as! HeaderTableViewCell
        
        headerCell.helpoutLabel.text = helpout.message
        
        helpout.creator.fetchIfNeededInBackgroundWithBlock { (object, error) in
            if object != nil && error == nil {
                let creator = object as! PFUser
                headerCell.creatorLabel.text = creator.firstName
                
                creator.imageFile?.getDataInBackgroundWithBlock() { (data, error) in
                    if data != nil && error == nil {
                        let image = UIImage(data: data!)
                        headerCell.creatorProfileButton.image = image
                    }
                }
            }
        }
        
        helpout.helper?.fetchIfNeededInBackgroundWithBlock { (object, error) in
            if object != nil && error == nil {
                let helper = object as! PFUser
                headerCell.helperLabel.text = helper.firstName
                
                helper.imageFile?.getDataInBackgroundWithBlock { (data, error) in
                    if data != nil && error == nil {
                        let image = UIImage(data: data!)
                        headerCell.helperProfileButton.image = image
                    }
                }
            }
        }
        
        return headerCell.contentView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if helpout.users.count > 0 {
            return 0
        } else {
            return FooterHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if helpout.users.count > 0 {
            return nil
        } else {
            return tableView.dequeueReusableCell(withIdentifier: FooterCell) as! FooterTableViewCell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if helpout.creator.objectId != PFUser.currentUser()?.objectId {
            return 1
        } else {
            return helpout.users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell, for: indexPath) as! UserTableViewCell
        return configureCell(cell, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if helpout.creator.objectId == PFUser.currentUser()?.objectId {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Mark") { (action, indexPath) in
            
            let user = self.helpout.users[indexPath.row]
            
            self.helpout.helper = user
            
            self.helpout.saveInBackgroundWithBlock { (success, error) in
                if success && error == nil {
                    tableView.reloadData()
                }
            }
        }
        action.backgroundColor = UIColor.helpoutsColor
        return [action]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // do nothing
    }
    
    func configureCell(_ cell: UserTableViewCell, atIndexPath indexPath: IndexPath) -> UserTableViewCell {
        
        var user: PFUser!
        
        if helpout.creator.objectId != PFUser.currentUser()?.objectId {
            user = helpout.creator
        } else {
            user = helpout.users[indexPath.row]
        }
        
        user.fetchIfNeededInBackgroundWithBlock { (object, error) in
            if object != nil && error == nil {
                user = object as! PFUser
                
                cell.nameLabel.text = user.firstName
                
                user.imageFile?.getDataInBackgroundWithBlock() { (data, error) in
                    if data != nil && error == nil {
                        let image = UIImage(data: data!)
                        cell.profileImageButton.image = image
                    }
                }
                
                let receiverQuery = Message.query()!
                receiverQuery.whereKey(Message.Keys.receiver, equalTo: PFUser.currentUser()!)
                receiverQuery.whereKey(Message.Keys.sender, equalTo: user)
                
                let senderQuery = Message.query()!
                senderQuery.whereKey(Message.Keys.receiver, equalTo: user)
                senderQuery.whereKey(Message.Keys.sender, equalTo: PFUser.currentUser()!)
                
                let compoundQuery = PFQuery.orQueryWithSubqueries([receiverQuery, senderQuery])
                compoundQuery.whereKey(Message.Keys.helpout, equalTo: self.helpout)
                compoundQuery.orderByDescending(Message.Keys.timestamp)
                
                compoundQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
                
                compoundQuery.getFirstObjectInBackgroundWithBlock { (object, error) in
                    if object != nil && error == nil {
                        let message = object as! Message
                        cell.messageLabel.text = message.message
                        cell.timeLabel.text = message.timestamp.humanReadable
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.Segues.MessagesSegue, sender: indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.MessagesSegue {
            if let messagesViewController = segue.destination as? MessagesViewController {
                let indexPath = sender as! IndexPath
                let correspondent: PFUser!
                if helpout.creator.objectId != PFUser.currentUser()?.objectId {
                    correspondent = helpout.creator
                } else {
                    correspondent = helpout.users[indexPath.row]
                }
                
                messagesViewController.helpout = self.helpout
                
                correspondent.fetchIfNeededInBackgroundWithBlock { (object, error) in
                    if object != nil && error == nil {
                        let user = object as! PFUser
                        messagesViewController.correspondent = user
                        messagesViewController.title = user.firstName
                        messagesViewController.refresh()
                        messagesViewController.setupProfileBarButton()
                    }
                }
            }
        }
    }
    
}
