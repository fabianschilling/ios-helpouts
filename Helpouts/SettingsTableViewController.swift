//
//  SettingsTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/19/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Class variables
    
    let defaults = UserDefaults.standard
    let ad = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Outlets
    
    @IBOutlet weak var notificationSwitch: UISwitch! {
        didSet {
            notificationSwitch.isOn = false // TODO: set based on subscription status
        }
    }
    
    @IBAction func notificationPreferencesChanged(_ sender: UISwitch) {
        if sender.isOn {
            // TODO: subscribe
        } else {
            // TODO: unsubscribe
        }
    }
    
    // MARK: Logout Logic
    
    func logout() {
        let logoutAlertController = UIAlertController(title: nil, message: "Do you really want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Log out", style: .Destructive){ (action: UIAlertAction!) in
            
            PFUser.logOutInBackgroundWithBlock() { (error) in
                if error != nil {
                    Log.log("Logout failed.")
                } else {
                    self.ad.window?.rootViewController = UIStoryboard.loginViewController
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action: UIAlertAction!) in
        }
        
        logoutAlertController.addAction(logoutAction)
        logoutAlertController.addAction(cancelAction)
        
        self.present(logoutAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero) // hide empty cells!
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1: performSegue(withIdentifier: Constants.Segues.ModelSegue, sender: self)
        case 2: logout()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let row = indexPath.row
        if row == 1 || row == 2 {
            return indexPath
        } else {
            return nil
        }
    }

}
