//
//  SelectHelperTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/12/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class SelectHelperTableViewController: UITableViewController {
    
    // MARK: - Class Variables
    
    let ReuseIdentifier = "HelperCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        // TODO: select helper
        /*
        sender.enabled = false
        cancelButton.enabled = false
        CloudManager.sharedInstance.updateHelperInHelpout(helpout, helper: currentHelper){ (updatedHelpout: Helpout) in
            self.performSegueWithIdentifier(Constants.Segues.UnwindToDetail, sender: self)
        }
        */
    }
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero) // hide empty cells!
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! HelperTableViewCell

        // TODO: configure cell
        /*
        let helper = helpers[indexPath.row]
        
        let image = helper.imageFromFile()
        cell.profileImageButton.setBackgroundImage(image, forState: .Normal)
        cell.nameLabel.text = helper.name
        */

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: select current helper
        /*
        currentHelper = helpers[indexPath.row]
        Log.log("\(currentHelper.name) selected.")
        if !doneButton.enabled {
            doneButton.enabled = true
        }
        */
    }

}
