//
//  ProfileViewController.swift
//  twitter
//
//  Created by vli on 10/4/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ProfileViewController: TimelineViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var tweetsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        user.getProfileBanner { (response, error) -> () in
//            if response != nil {
//                self.backgroundImgView.setImagewithURL(NSURL(string: response!))
//            }
//        }

        if user!.headerImgUrl != nil {
            self.backgroundImgView.setImagewithURL(NSURL(string: user!.headerImgUrl!))
        }
        numTweetsLabel.text = "\(user!.numTweets) Tweets"
        numFollowersLabel.text = "\(user!.followersCount) Followers"
        numFollowingLabel.text = "\(user!.friendsCount) Following"
        
        var tweetsVC = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as HomeViewController
        tweetsVC.user = user
        self.addChildViewController(tweetsVC)
        tweetsVC.view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        tweetsVC.view.frame = self.tweetsView.bounds
        self.tweetsView.addSubview(tweetsVC.view)
        tweetsVC.didMoveToParentViewController(self)
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.translucent = true
//        navigationController?.view.backgroundColor = UIColor.clearColor()
        
        navigationItem.title = user!.displayName
    }
    
//    override func fetchTweets(#paging: Bool) {
//        var params = ["count": "\(REQUEST_COUNT)"]
//        if paging {
//            params["since_id"] = self.tweets!.last!.identifier
//        }
//        TwitterClient.sharedInstance.userTimelineWithParams(user.handle, params: params, completion: handleTimelineRequest)
//    }
//    override func handleTimelineRequest(tweets: [Tweet]?, error: NSError?) -> () {
//        super.handleTimelineRequest(tweets, error: error)
//        self.tableView.reloadData()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
