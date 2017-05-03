//
//  SignupTableViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/3/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class SignupTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Class Variables
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImageButton: CircleButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // MARK: Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        performSegue(withIdentifier: Constants.Segues.UnwindToLogin, sender: nil)
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alertContoller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { alert in
            if UIImagePickerController.availableCaptureModes(for: UIImagePickerControllerCameraDevice.front) != nil {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                Log.log("Front camera not available")
            }
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { alert in
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
        }
        
        alertContoller.addAction(takePhotoAction)
        alertContoller.addAction(choosePhotoAction)
        alertContoller.addAction(cancelAction)
        
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    fileprivate func startBackgroundTask() {
        view.isUserInteractionEnabled = false
        view.endEditing(true)
        spinner.startAnimating()
    }
    
    fileprivate func stopBackgroundTask() {
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        if !areValidCredentials() {
            return
        }
        
        startBackgroundTask()
        
        let password = passwordTextField.text
        let password2 = password2TextField.text
        let firstName = nameTextField.text
        let email = emailTextField.text
        let image = profileImageButton.backgroundImage(for: UIControlState())!
        let imageFile = PFFile(data: UIImageJPEGRepresentation(image, 1.0), contentType: "image/jpeg")
        
        var user = PFUser()
        user.password = password
        user.email = email
        user.username = email
        user.firstName = firstName
        user.imageFile = imageFile
        
        user.signUpInBackgroundWithBlock { (success, error) in
            
            self.stopBackgroundTask()
            
            if success {
                Log.log("User \(firstName) signed up successully")
            } else {
                Alert.showAlert("Signup Error", message: "The email \(email) is already taken.")
            }
        }

    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        editPhotoButton.setTitle("Edit photo", for: UIControlState())
        profileImageButton.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            password2TextField.becomeFirstResponder()
        } else if textField == password2TextField {
            password2TextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Credential Validation
    
    func areValidCredentials() -> Bool {
        if !(nameTextField.text?.isValidName)! {
            Alert.showAlert(Alert.Name.Title, message: Alert.Name.Message)
            return false
        } else if !(emailTextField.text?.isValidEmail)! {
            Alert.showAlert(Alert.Email.Title, message: Alert.Email.Message)
            return false
        } else if !(passwordTextField.text?.isValidPassword)! {
            Alert.showAlert(Alert.Password.Title, message: Alert.Password.Message)
            return false
        } else if !(password2TextField.text?.isValidPassword)! {
            Alert.showAlert(Alert.Password.Title, message: Alert.Password.Message)
            return false
        } else if passwordTextField.text != password2TextField.text {
            Alert.showAlert(Alert.PasswordMatch.Title, message: Alert.PasswordMatch.Message)
            return false
        } else {
            return true
        }
    }
    
    // MARK: TapGestureRecognizer
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }    
}

