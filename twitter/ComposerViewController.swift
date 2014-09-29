
//  ComposerViewController.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

let maxStatusLength = 140
let defaultBottomConstraint = 15.0

class ComposerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var textBottomConstraint: NSLayoutConstraint!
    
    var tweetToReply: Tweet?
    
    @IBAction func didCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPost(sender: AnyObject) {
        let tweet = Tweet.postTweet(statusTextView.text)
        if tweet != nil {
            // Pass tweet back to view controller with delegate
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        // keyboard will show -- change constraint from the height of the keyboard
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            // UIKeyboardEndFrame wrapped in NSValue from User settings
            let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            let rect = value.CGRectValue()
            
            NSLog("Height: \(rect.size.height)")
            self.textBottomConstraint.constant = rect.size.height + 5
            return () // must return void
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            self.textBottomConstraint.constant = CGFloat(defaultBottomConstraint)
            return ()
        }
        
        statusTextView.delegate = self
        
        let currentUser = User.currentUser
        displayNameLabel.text = currentUser!.displayName
        handleLabel.text = "@\(currentUser!.handle)"
        profileImgView.setProfileImageWithURL(NSURL(string: currentUser!.profileImgUrl))
        if tweetToReply != nil {
            statusTextView.text = "@\(tweetToReply!.user.handle) "
        }
        updateCharacterCount(countElements(statusTextView.text))
        
        statusTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let curStatusLength = countElements(textView.text)
        let newStatusLength = curStatusLength + countElements(text) - range.length
        if newStatusLength > maxStatusLength {
            return false
        } else {
            updateCharacterCount(newStatusLength)
            return true
        }
    }
    
    func updateCharacterCount(currentStatusLength: Int) {
        countdownLabel.text = "\(maxStatusLength - currentStatusLength)"
    }

}
