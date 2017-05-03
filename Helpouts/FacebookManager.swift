//
//  FacebookFetcher.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/14/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class FacebookManager {
    
    static let sharedInstance = FacebookManager()
    
    let FacebookGraph = "http://graph.facebook.com"
    
    func fetchFacebookUser(_ successHandler: @escaping (_ user: FacebookUser) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            request.startWithCompletionHandler() { (_, result: AnyObject!, error: NSError!) in
                
                if error != nil {
                    dispatch_async(Queue.MainQueue) {
                        Alert.showAlert("Facebook Error", message: error.localizedDescription)
                    }
                } else {
                    dispatch_async(Queue.MainQueue) {
                        if let user = result as? [String: AnyObject] {
                            successHandler(user: FacebookUser(user: user))
                        }
                    }
                }
            }
        }
    }
    
    func fetchProfileImage(_ userID: String, successHandler: (_ image: UIImage) -> ()) {
        let imageURL = URL(string: "\(FacebookGraph)/\(userID)/picture?type=square&width=400&height=400")!
        Queue.UserInteractiveQueue.async {
            let imageData = try! Data(contentsOf: imageURL)
            let image = UIImage(data: imageData)!
            (Queue.MainQueue).async {
                successHandler(image: image)
            }
        }
        
    }
    
    // TODO: login or signup
    
    /*
    func loginOrSignupWithFacebook(successHandler: (user: User) -> Void) {
        
        // Fetch facebook user
        FacebookManager.sharedInstance.fetchFacebookUser(){ (facebookUser: FacebookUser) in
            
            Log.log("Facebook user \(facebookUser.firstName) fetched.")
            
            // If the user is already saved locally...
            if let currentUser = User.fetchUser(facebookUser.email, attributeName: Constants.Attributes.Email) {
                
                Log.log("Getting user \(currentUser.name) locally.")
                
                successHandler(user: currentUser)
            } else {
                
                Log.log("Getting user \(facebookUser.name) remotely.")
                
                // Fetch user remotely with Facebook email address
                CloudManager.sharedInstance.fetchUser(facebookUser.email){ (fetchedUser: User?) in
                    
                    // If there is a record in the cloud, the user has an account already
                    if fetchedUser != nil {
                        
                        Log.log("Facebook user \(fetchedUser!.name) already has an account. Logging in...")
                        
                        successHandler(user: fetchedUser!)
                    } else {
                        
                        Log.log("Facebook user \(facebookUser.name) does not have an account yet.")
                        
                        // Fetch the user's Facebook profile image
                        FacebookManager.sharedInstance.fetchProfileImage(facebookUser.id){ (image: UIImage) in
                            
                            let imageAsset = image.toCKAsset()
                            Log.log("Facebook profile picture of user \(facebookUser.name) fetched.")
                            
                            // Create new user in the cloud
                            CloudManager.sharedInstance.createUser(facebookUser.email, password: "facebook", name: facebookUser.firstName, image: imageAsset) { (createdUser: User) in
                                
                                Log.log("Creating account for Facebook user \(facebookUser.name). Logging in...")
                                
                                successHandler(user: createdUser)
                            }
                        }
                    }
                }
            }
        }
    }
    */
}
