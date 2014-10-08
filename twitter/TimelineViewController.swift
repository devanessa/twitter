//
//  TimelineViewController.swift
//  twitter
//
//  Created by vli on 10/5/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

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

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileImageTappedDelegate {
    var apiType: APIType = APIType.Timeline
    
    var tweets: [Tweet]?
    var noMoreTweets: Bool = false
    
    let REQUEST_COUNT = 15
    
    var isPaging = false
    
    var spinnerCellId, retweetCellId, tweetCellId: String?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchTweets(paging: Bool = false) {
        var params: NSDictionary?
        if paging {
            isPaging = true
            let oldestId = self.tweets!.last!.identifier.toInt()! - 1
            params = ["max_id": oldestId, "include_rts": "1"]
        } else {
            isPaging = false
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
            if self.tweets == nil || !isPaging {
                self.tweets = tweets
            } else {
                self.tweets! += tweets!
            }
            if tweets!.count < REQUEST_COUNT {
                noMoreTweets = true
            }
        } else {
            noMoreTweets = true
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.tweets!.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(spinnerCellId!) as UITableViewCell
            if !noMoreTweets {
                fetchTweets(paging: true)
            } else {
                tableView.reloadData()
            }
            return cell
        } else if indexPath.row == 0 && user != nil {
            // Present the stats for a user profile table
            let cell = tableView.dequeueReusableCellWithIdentifier("statsCell") as StatsTableViewCell
            cell.numFollowersLabel.text = "\(user!.followersCount) Followers"
            cell.numFollowingLabel.text = "\(user!.friendsCount) Following"
            cell.numTweetsLabel.text = "\(user!.numTweets) Tweets"
            return cell
        } else {
            let tweet = tweets![indexPath.row]
            if tweet.retweet != nil {
                let cell = tableView.dequeueReusableCellWithIdentifier(retweetCellId!) as RetweetTableViewCell
                cell.populateCellFromTweet(tweet)
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellId!) as TweetTableViewCell
                cell.populateCellFromTweet(tweet)
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            let tweetCount = self.tweets!.count
            var extrasCount = 0
            if !noMoreTweets {
                extrasCount += 1
            }
            if user != nil {
                // this is for the stats profile cell
                extrasCount += 1
            }
            return tweetCount + extrasCount
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("tweetDetails", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    func didTapProfileImg(user: User) {
        if user.handle != self.user?.handle {
            // push profile view controller into view
            let pVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            pVC.user = user
            self.navigationController?.pushViewController(pVC, animated: true)
        }
    }
}



