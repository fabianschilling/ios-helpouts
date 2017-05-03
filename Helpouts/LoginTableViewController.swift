//
//  LoginTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/3/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Class Variables
    
    fileprivate let ad = UIApplication.shared.delegate as! AppDelegate
    fileprivate let defaults = UserDefaults.standard
    
    // MARK: - Desinated Initializer
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var appIcon: CircleButton!
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        login()
    }
    
    @IBAction func loginWithFacebookButtonTapped(_ sender: UIButton) {
        loginWithFacebook()
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.SignupSegue, sender: self)
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIcon.layer.borderWidth = 0
    }
    
    // MARK: - TapGestureRecognizer

    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Background Tasks
    
    fileprivate func startBackgroundTask() {
        view.isUserInteractionEnabled = false
        spinner.startAnimating()
        view.endEditing(true)
    }
    
    fileprivate func stopBackgroundTask() {
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
    }
    
    // MARK: - Login Logic
    
    fileprivate func login() {
        
        startBackgroundTask()
        
        if !validateTextFields() {
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) in
            
            self.stopBackgroundTask()
            
            if let currentUser = user {
                Log.log("User \(currentUser.email!) logged in successfully")
                self.proceedToLogin()
            } else {
                Log.log(error!.localizedDescription)
            }
        }
    }
    
    // MARK: Login with Facebook Logic
    
    func loginWithFacebook() {
        
        let permissions = ["email", "public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions){ (user, error) in
            if user == nil {
                Log.log("Facebook login cancelled.")
            } else if user!.isNew {
                Log.log("User logged in through Facebook. Signing up.")
                self.signupWithFacebook()
            } else {
                Log.log("User logged in through Facebook.")
                self.proceedToLogin()
            }
        }
    }
    
    func signupWithFacebook() {
        
        startBackgroundTask()
        
        let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler { (connection, result, error) in
            
            if error != nil {
                Alert.showAlert("Facebook Error", message: error.localizedDescription)
            } else {
                let userDict = result as! [String: AnyObject]
                let facebookUser = FacebookUser(user: userDict)
                Log.log("Fetched Facebook user data.")
                facebookUser.fetchProfileImage() { (imageData) in
                    
                    let user = PFUser.currentUser()
                    
                    if let data = imageData {
                        Log.log("Facebook profile image fetched.")
                        user?.imageFile = PFFile(data: data)
                    }
                    
                    user?.username = facebookUser.email
                    user?.email = facebookUser.email
                    user?.firstName = facebookUser.firstName
                    
                    user?.saveInBackgroundWithBlock() { (success, errror) in
                        
                        Log.log("User saved.")
                        self.stopBackgroundTask()
                        self.proceedToLogin()
                    }
                }
            }
        }
    }
    
    func proceedToLogin() {
        let installation = PFInstallation.currentInstallation()
        installation.user = PFUser.currentUser()
        installation.saveInBackground()
        self.passwordTextField.text = ""
        self.ad.window?.rootViewController = UIStoryboard.mainViewController
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - UITextField validation
    
    func validateTextFields() -> Bool{
        if !(emailTextField.text?.isValidEmail)! {
            Alert.showAlert(Alert.Email.Title, message: Alert.Email.Message)
            return false
        } else if !(passwordTextField.text?.isValidPassword)! {
            Alert.showAlert(Alert.Password.Title, message: Alert.Password.Message)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        
    }
}
