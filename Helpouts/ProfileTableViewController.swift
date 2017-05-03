//
//  ProfileTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/17/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Class variables
    
    fileprivate let ad = UIApplication.shared.delegate as! AppDelegate
    fileprivate let defaults = UserDefaults.standard
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageButton: CircleButton! {
        didSet {
            PFUser.currentUser()?.imageFile?.getDataInBackgroundWithBlock(){ (data, error) in
                if data != nil && error == nil {
                    let image = UIImage(data: data!)
                    self.profileImageButton.image = image
                }
            }
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = "Novice Helper"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.OutgoingSegue, sender: self)
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.currentUser()?.firstName
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.OutgoingSegue {
            if let navController = segue.destination as? UINavigationController {
                if let outgoingViewController = navController.topViewController as? OutgoingTableViewController {
                    // Prepare for outgoing segue
                }
            }
        }
    }
    
    @IBAction func unwindToProfile(_ segue: UIStoryboardSegue) {
        // do nothing
    }

}
