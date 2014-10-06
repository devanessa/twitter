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

enum APIType {
    case Timeline, Mentions
    
    func titleString() -> String {
        switch self {
        case .Timeline:
            return "Home"
        case .Mentions:
            return "Mentions"
        }
    }
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StatusPostDelegate, StatusUpdateDelegate, ProfileImageTappedDelegate {
    var apiType: APIType = APIType.Timeline
    var user: User?
    var tweets: [Tweet]?
    var noMoreTweets: Bool = false
    
    let REQUEST_COUNT = 15
    
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

        navigationItem.title = apiType.titleString()
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
    
    func fetchTweets(paging: Bool = false) {
//        var params = ["count": "\(REQUEST_COUNT)"]
        var params: NSDictionary?
        if paging {
//            params["since_id"] = self.tweets!.last!.identifier
            let oldestId = self.tweets!.last!.identifier.toInt()! - 1
            params = ["max_id": oldestId, "include_rts": "1"]
        }
        if user != nil {
            // Get timeline view for particular user
            TwitterClient.sharedInstance.userTimelineWithParams(user!.handle, params: params, completion: handleTimelineRequest)
        } else {
            if apiType == APIType.Timeline {
                TwitterClient.sharedInstance.homeTimelineWithParams(params, completion: handleTimelineRequest)
            } else if apiType == APIType.Mentions {
                TwitterClient.sharedInstance.userMentionsWithParams(params, completion: handleTimelineRequest)
            }
        }
    }

    func handleTimelineRequest(tweets: [Tweet]?, error: NSError?) -> () {
        if tweets != nil {
            println("got \(tweets!.count) tweets")
            if self.tweets == nil {
                self.tweets = tweets
            } else {
                self.tweets! += tweets!
            }
            if tweets!.count < REQUEST_COUNT {
                noMoreTweets = true
            }
            self.tableView.reloadData()
        } else {
            noMoreTweets = true
        }
    }
    
    func refreshData() {
        fetchTweets()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.tweets!.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("spinnerCell") as UITableViewCell
            if !noMoreTweets {
                fetchTweets(paging: true)
            } else {
                tableView.reloadData()
            }
            return cell
        } else {
            let tweet = tweets![indexPath.row]
            if tweet.retweet != nil {
                let cell = tableView.dequeueReusableCellWithIdentifier("retweetCell") as RetweetTableViewCell
                cell.populateCellFromTweet(tweet)
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
                cell.populateCellFromTweet(tweet)
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            if noMoreTweets {
                return self.tweets!.count
            } else {
                return self.tweets!.count + 1
            }
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

    func didTapProfileImg(user: User) {
        if user.handle != self.user?.handle {
            // push profile view controller into view
            let pVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            pVC.user = user
//            self.performSegueWithIdentifier(<#identifier: String#>, sender: <#AnyObject?#>)
            self.navigationController?.pushViewController(pVC, animated: true)
        }
    }
}



