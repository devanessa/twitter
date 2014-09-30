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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StatusPostDelegate, StatusUpdateDelegate {
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: [NSForegroundColorAttributeName : UIColor.blackColor()])
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        fetchTweets()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    func refreshData() {
        fetchTweets()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets![indexPath.row]
        if tweet.retweet != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("retweetCell") as RetweetTableViewCell
            cell.populateCellFromTweet(tweet)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
            cell.populateCellFromTweet(tweet)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("tweetDetails", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "tweetDetails") {
            var statusViewController = segue.destinationViewController as StatusViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            let tweet = tweets![indexPath!.row]
            
            statusViewController.delegate = self
            statusViewController.tweet = tweet
            
        } else if (segue.identifier == "composeSegue") {
            var composerVC = segue.destinationViewController as ComposerViewController
            
            composerVC.delegate = self
        }

    }

    func didPostReply(tweet: Tweet) {
        insertTweetAtTop(tweet)
    }
    
    func didUpdateDataAtRow(row: Int, tweet: Tweet) {
        // update cell view?
    }
    
    func didPostTweet(tweet: Tweet) {
        self.dismissViewControllerAnimated(true, completion: nil)
        insertTweetAtTop(tweet)
    }
    
    func insertTweetAtTop(tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }

}

