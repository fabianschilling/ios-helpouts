//
//  MessagesViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/21/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import CoreLocation

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Class variables
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    
    var helpout: Helpout!
    var correspondent: PFUser!
    var messages: [Message] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fakeSendButton: UIButton!
    @IBOutlet weak var fakeMessageTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var fakeProgressView: UIProgressView!
    
    @IBOutlet var accessoryView: UIView! {
        didSet {
            accessoryView.tintColor = UIColor.helpoutsColor
        }
    }
    
    // MARK: - Actions
   
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendMessage(messageTextField.text!, location: nil)
        fakeMessageTextField.text = ""
        messageTextField.text = ""
        fakeSendButton.isEnabled = false
        sendButton.isEnabled = false
        tableView.reloadData()
        scrollToBottom(true)
    }
    
    func profileImageTapped() {
        
        //TODO: profile image tapped
    
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        messageTextField.resignFirstResponder()
        
        let shareController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareLocationAction = UIAlertAction(title: "Share location", style: .default) { (alert: UIAlertAction!) in
            let currentLocation = LocationManager.sharedInstance.currentLocation
            self.sendMessage("Location", location: currentLocation)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
            // do nothing
        }
    
        shareController.addAction(shareLocationAction)
        shareController.addAction(cancelAction)
        
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handleMessageNotification(_:)), name: NSNotification.Name(rawValue: Constants.Actions.Message), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80 // this causes lag when scrolling up
        let tabBarHeight = tabBarController!.tabBar.bounds.size.height
        var inset = tableView.contentInset
        inset.bottom = -tabBarHeight
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
    func handleMessageNotification(_ notification: Notification) {
        Log.log("Refreshing messages because of push notification.")
        refresh()
    }
    
    func refresh() {
        
        let receiverQuery = Message.query()!
        receiverQuery.whereKey(Message.Keys.receiver, equalTo: PFUser.currentUser()!)
        receiverQuery.whereKey(Message.Keys.sender, equalTo: correspondent)
        
        let senderQuery = Message.query()!
        senderQuery.whereKey(Message.Keys.receiver, equalTo: correspondent)
        senderQuery.whereKey(Message.Keys.sender, equalTo: PFUser.currentUser()!)
        
        let compoundQuery = PFQuery.orQueryWithSubqueries([receiverQuery, senderQuery])
        compoundQuery.whereKey(Message.Keys.helpout, equalTo: helpout)
        compoundQuery.orderByAscending(Message.Keys.timestamp)
        
        compoundQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        compoundQuery.findObjectsInBackgroundWithBlock { (results, error) in
            
            if results != nil && error == nil {
                let fetchedMessages = results as! [Message]
                self.messages = fetchedMessages
                self.tableView.reloadData()
                self.scrollToBottom(false)
            } else {
                Log.log(error!.localizedDescription)
            }
        }
        
        
    }
    
    // MARK: - Profile Bar Button Item
    
    func setupProfileBarButton() {
        let circleButton = CircleButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        correspondent.imageFile?.getDataInBackgroundWithBlock() { (data, error) in
            if data != nil && error == nil {
                let image = UIImage(data: data!)
                circleButton.image = image
            }
        }
        
        circleButton.layer.borderWidth = 0
        circleButton.addTarget(self, action: #selector(MessagesViewController.profileImageTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: circleButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - UITapGestureRecognizer
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        messageTextField.resignFirstResponder()
    }
    
    // MARK: Messages Logic
    
    func sendMessage(_ messageText: String, location: CLLocation?) {
        
        self.setProgress(0.75, animated: true)
        
        var message = Message()
        message.message = messageText
        message.helpout = helpout
        message.sender = PFUser.currentUser()!
        if let currentLocation = location {
            message.geoPoint = PFUser.currentUser()!.geoPoint!
        }
        message.receiver = correspondent
        message.timestamp = Date()
        
        message.saveInBackgroundWithBlock(){ (success, error) in
            if success && error == nil {
                Log.log("Message sent!")
                self.messages.append(message)
                self.setProgress(1.0, animated: true)

                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Actions.Message, object: nil)
                
                self.tableView.reloadData()
                self.scrollToBottom(true)
                
                // Push notification
                let pushQuery = PFInstallation.query()!
                pushQuery.whereKey(PFInstallation.Keys.user, equalTo: self.correspondent)
                
                let push = PFPush()
                push.setQuery(pushQuery)
                push.setData([Constants.Alert: "\(PFUser.currentUser()!.firstName!): \(messageText)", Constants.Action: Constants.Actions.Message, Constants.Object: message.objectId!])
                
                push.sendPushInBackgroundWithBlock { (success, error) in
                    if success && error == nil {
                        Log.log("Message push notification sent.")
                    }
                }
                
                
            }
        }
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let message = messages[indexPath.row]
        
        // Decision if incoming or outgoing message
        if message.sender.objectId == correspondent.objectId {
            
            // Check if the message contains a location value
            if let geoPoint = message.geoPoint {
                
                let locationCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.IncomingLocation, for: indexPath) as! IncomingLocationTableViewCell
                locationCell.location = geoPoint.location
                locationCell.mapButton.message = message
                locationCell.mapButton.addTarget(self, action: #selector(MessagesViewController.mapButtonTapped(_:)), for: .touchUpInside)
                return locationCell
                
            } else {
                
                let messageCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.IncomingMessage, for: indexPath) as! IncomingMessageTableViewCell
                messageCell.messageLabel.text = message.message
                return messageCell
            }

            
        } else {
            
            if let geoPoint = message.geoPoint {
                
                let locationCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.OutgoingLocation, for: indexPath) as! OutgoingLocationTableViewCell
                locationCell.location = geoPoint.location
                locationCell.mapButton.message = message
                locationCell.mapButton.addTarget(self, action: #selector(MessagesViewController.mapButtonTapped(_:)), for: .touchUpInside)
                return locationCell
                
            } else {
                
                let messageCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.OutgoingMessage, for: indexPath) as! OutgoingMessageTableViewCell
                messageCell.messageLabel.text = message.message
                return messageCell
            }
        }
        
    }
    
    // MARK: - Map Target Action
    
    func mapButtonTapped(_ sender: MapButton) {
        performSegue(withIdentifier: Constants.Segues.MapSegue, sender: sender.message)
    }
    
    // MARK: - UIKeyboardDidHide/ShowNotification
    
    func keyboardWillShow(_ notification: Notification) {
        messageTextField.becomeFirstResponder()
        let keyboardHeight = getKeyboardHeight(notification)
        var inset = tableView.contentInset
        let tabBarHeight = tabBarController!.tabBar.bounds.size.height
        inset.bottom = keyboardHeight - accessoryView.frame.size.height - tabBarHeight
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        scrollToBottom(true)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        fakeMessageTextField.text = messageTextField.text
        fakeSendButton.isEnabled = sendButton.isEnabled
        var inset = tableView.contentInset
        inset.bottom = CGFloat(0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        return (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = accessoryView
        messageTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text as NSString
        let newText = text.stringByReplacingCharactersInRange(range, withString: string)
        sendButton.enabled = (count(newText) > 0)
        return true
    }
    
    // MARK: - Scrolling
    
    func scrollToBottom(_ animated: Bool) {
        if messages.count > 1 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    // MARK: - UIProgressView
    
    func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
        fakeProgressView.setProgress(progress, animated: animated)
        if progress == 1.0 {
            var times = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MessagesViewController.hideProgressView), userInfo: nil, repeats: false)
        }
    }
    
    func hideProgressView() {
        progressView.setProgress(0.0, animated: false)
        fakeProgressView.setProgress(0.0, animated: false)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.MapSegue {
            
            if let mapViewController = segue.destination as? MapViewController {
                
                //mapViewController.navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItem
                
                if let message = sender as? Message {
                    
                    mapViewController.location = message.geoPoint?.location
                    
                    message.sender.fetchIfNeededInBackgroundWithBlock { (object, error) in
                        
                        let messageSender = object as! PFUser
                        
                        if messageSender.objectId == PFUser.currentUser()?.objectId {
                            mapViewController.title = "My Location"
                            mapViewController.annotationTitle = "Me"
                        } else {
                            mapViewController.title = "\(messageSender.firstName!)'s Location"
                            mapViewController.annotationTitle = messageSender.firstName!
                        }
                    }
                }
            }
        }
    }
    
}
