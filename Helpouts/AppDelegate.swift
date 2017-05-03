//
//  AppDelegate.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/12/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Enable Parse database
        //Parse.enableLocalDatastore()
        
        // Register subclasses
        Message.registerSubclass()
        Helpout.registerSubclass()
        
        
        // Setup Parse
        Parse.setApplicationId("XZfXVxH3nqNkq3VDJ10dosFm1wlDkUFNU3L0Lxfj",
            clientKey: "XmIXakjWMeRyy6VxeGJJ54emDPSfqBPuZxeMWxst")
        
        // Enable revocable sessions
        PFUser.enableRevocableSessionInBackground()
        
        // Initialize Analytics
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Initialize Facebook
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.background {
            
            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayloadAvailable = false
            if let options = launchOptions {
                pushPayloadAvailable = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil
                
                // Handle push notification in background
                
                if pushPayloadAvailable {
                    
                    let pushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] as! [NSString: AnyObject]
                    let objectID = pushPayload["p"] as! String
                    let object = PFObject(withoutDataWithObjectId: objectID)
                    
                    object.fetchIfNeededInBackgroundWithBlock { (fetchedObject, error) in
                        if fetchedObject != nil && error == nil {
                            Log.log("Object fetched from push notification in background: \(fetchedObject)")
                        }
                    }
                    
                }
                
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayloadAvailable) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        // Register for Push Notifications
        let userNotificationTypes: UIUserNotificationType = .Alert | .Badge | .Sound
        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        // Start reachability
        let networkManager = NetworkManager.sharedInstance
        
        // Start location manager
        LocationManager.sharedInstance.updateLocation()
        
        // Set global tint color
        self.window?.tintColor = UIColor.helpoutsColor
        
        
        let defaults = UserDefaults.standard
        
        if PFUser.current() != nil {
            self.window?.rootViewController = UIStoryboard.mainViewController
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Log.log("Application did receive remote notification with completion handler.")
        
        //PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        Log.log(userInfo)
        
        if let action = userInfo[Constants.Action] as? String {
            
            switch action {
            case Constants.Actions.Message:
                Log.log("Handling message notification.")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Actions.Message), object: nil)
            case Constants.Actions.HelpoutCreated:
                Log.log("Handling helpout created notification.")
                if let objectID = userInfo[Constants.Object] as? String {
                    let query = Helpout.query()!
                    query.getObjectInBackgroundWithId(objectID) { (object, error) in
                        if object != nil && error == nil {
                            let helpout = object as! Helpout
                            let incomingViewController = UIStoryboard.incomingViewController
                            (incomingViewController.topViewController as! IncomingTableViewController).helpout = helpout
                            self.window?.rootViewController?.presentViewController(incomingViewController, animated: true, completion: nil)
                        }
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Actions.HelpoutCreated), object: nil)
            case Constants.Actions.HelpoutDeleted:
                Log.log("Handling helpout deleted notification.")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Actions.HelpoutDeleted), object: nil)
            case Constants.Actions.HelpoutUpdated:
                Log.log("Handling helpout updated notification.")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Actions.HelpoutUpdated), object: nil)
            case Constants.Actions.HelpoutUnsubscribed:
                Log.log("Handling helpout unsubscribed notificaiton.")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Actions.HelpoutUnsubscribed), object: nil)
            default:
                Log.log("Unrecognized action.")
            }
        }
        
        completionHandler(UIBackgroundFetchResult.noData)
    }

    // MARK: - UIRemoteNotification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.log("Application did register for remote notifications.")
        let installation = PFInstallation.current()
        installation.setDeviceTokenFrom(deviceToken)
        installation.user = PFUser.currentUser()
        installation.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.log("Application did fail to register for remote notifications: \(error.localizedDescription)")
        if error.code == 3010 {
            Log.log("Push notifications are not supported in the iOS Simulator.")
        } else {
            Log.log(error.localizedDescription)
        }
    }

}

