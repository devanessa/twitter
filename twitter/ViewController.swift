//
//  ViewController.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var statuses: [Status]?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    @IBAction func didTapNew(sender: AnyObject) {
        let composer = ComposerViewController(nibName: nil, bundle: nil)
        self.navigationController?.presentViewController(composer, animated: true, completion: {
            
        })
    }
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
            if success {
                let accounts = accountStore.accountsWithAccountType(accountType)
                NSLog("Accounts: \(accounts)")
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") //test for nil or unicode-safe parsing library!
//                let url = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
                if accounts.count == 0 {
                    NSLog("Accounts is empty")
                } else {
                    authRequest.account = accounts[0] as ACAccount
                    
                    let request = authRequest.preparedURLRequest()
                    
                    // Wrap this in resource
                    let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        if error != nil {
                            NSLog("error getting timeline")
                        } else {
                            let array = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
                            
                            var statusArray:[Status] = Array()
                            for obj in array {
                                let dictionary = obj as NSDictionary
                                statusArray.append(Status(dictionary: dictionary))
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.statuses = statusArray
                                self.tableView.reloadData()
                                
                            }) // always run on main thread
                            
                            NSLog("Got dictionary: \(array)")
                        }
                    })
                    task.resume()   // This will actualy kick off the request
                }
            } else {
                NSLog("Error: \(error)")
            }
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshData() {
        // Call api instead
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        if status.retweet != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("retweetCell") as RetweetTableViewCell
            cell.populateCellFromStatus(status)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
            cell.populateCellFromStatus(status)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.statuses != nil {
            return self.statuses!.count
        } else {
            return 0
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
}

