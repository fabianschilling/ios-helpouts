//
//  CoreDataTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/23/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CoreData

class ModelTableViewController: UITableViewController {
    
    // TODO: new model, new logic
    
    /*
    func fetchAll(entityName: String) {
        let request = NSFetchRequest(entityName: entityName)
        let items = context?.executeFetchRequest(request, error: nil) as! [NSManagedObject]
        for item in items {
            Log.log(item)
        }
    }
    
    // MARK: Deletion logic
    
    func deleteAll(entityName: String) {
        let request = NSFetchRequest(entityName: entityName)
        request.includesPropertyValues = false
        let items = context?.executeFetchRequest(request, error: nil) as! [NSManagedObject]
        for item in items {
            context?.deleteObject(item)
            Log.log("\(item) deleted. ")
        }
        context?.save(nil)
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: fetchAll(Constants.Entities.User)
            case 1: fetchAll(Constants.Entities.Helpout)
            case 2: fetchAll(Constants.Entities.Message)
            case 3: deleteAll(Constants.Entities.User)
            case 4: deleteAll(Constants.Entities.Helpout)
            case 5: deleteAll(Constants.Entities.Message)
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0: SubscriptionManager.sharedInstance.fetchAllSubscriptions()
            case 1: SubscriptionManager.sharedInstance.deleteAllSubscriptions()
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0: Log.log(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
            default: break
            }
        default: break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    */
}
