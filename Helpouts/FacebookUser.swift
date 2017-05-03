//
//  FacebookUser.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/26/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class FacebookUser {
    
    var email: String
    var lastName: String
    var locale: String
    var timezone: Int
    var gender: String
    var name: String
    var firstName: String
    var facebookID: String
    var pictureURL: URL
    
    init(user: [String: AnyObject]) {
        self.email = user["email"] as! String // Fix: only works with public email addresses
        self.lastName = user["last_name"] as! String
        self.locale = user["locale"] as! String
        self.timezone = user["timezone"] as! Int
        self.gender = user["gender"] as! String
        self.name = user["name"] as! String
        self.firstName = user["first_name"] as! String
        self.facebookID = user["id"] as! String
        self.pictureURL = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=square&width=400&height=400")!
    }
    
    func fetchProfileImage(_ completionHandler: @escaping (_ imageData: Data?) -> Void) {
        Queue.UserInteractiveQueue.async {
            let data = try? Data(contentsOf: self.pictureURL)
            Queue.MainQueue.async {
                completionHandler(imageData: data)
            }
        }
    }
}
