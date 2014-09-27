//
//  ComposerViewController.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController {

    @IBAction func didCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            NSLog("User info: \(notification.userInfo!)")
            let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            let rect = value.CGRectValue()
            
            NSLog("Height: \(rect.size.height)")
            return () // must return void
        }
        
        // keyboard will show -- change constraint from the height of the keyboard
        // UIKeyboardEndFrame wrapped in NSValue from User settings
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
