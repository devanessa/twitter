//
//  ViewController.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit


class HomeViewController: TimelineViewController, StatusPostDelegate, StatusUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: [NSForegroundColorAttributeName : UIColor.blackColor()])
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        fetchTweets()
        
        spinnerCellId = "spinnerCell"
        retweetCellId = "retweetCell"
        tweetCellId = "tweetCell"

        navigationItem.title = apiType.titleString()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }

    override func handleTimelineRequest(tweets: [Tweet]?, error: NSError?) -> () {
        super.handleTimelineRequest(tweets, error: error)
        self.tableView.reloadData()
    }
    
    func refreshData() {
        fetchTweets()
        refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "tweetDetails") {
            var statusViewController = segue.destinationViewController as StatusViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            let tweet = tweets![indexPath!.row]
            
            statusViewController.delegate = self
            statusViewController.tweet = tweet
            statusViewController.rowIndex = indexPath!.row
            
        } else if (segue.identifier == "composeSegue") {
            var composerVC = segue.destinationViewController as ComposerViewController
            
            composerVC.delegate = self
        }

    }

    func didPostReply(tweet: Tweet) {
        insertTweetAtTop(tweet)
    }
    
    func didUpdateDataAtRow(row: Int, tweet: Tweet) {
        // update tweet object for tweet in array
        tweets![row] = tweet
        // reload here?
    }
    
    func didPostTweet(tweet: Tweet) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println(tweet.text)
        insertTweetAtTop(tweet)
    }
    
    func insertTweetAtTop(tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
}



