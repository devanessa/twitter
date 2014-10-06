//
//  ProfileViewController.swift
//  twitter
//
//  Created by vli on 10/4/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    var user: User!
    var tweets: [Tweet]?
    
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    @IBOutlet weak var tweetsView: UIView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        user.getProfileBanner { (response, error) -> () in
//            if response != nil {
//                self.backgroundImgView.setImagewithURL(NSURL(string: response!))
//            }
//        }

        if user.headerImgUrl != nil {
            self.backgroundImgView.setImagewithURL(NSURL(string: user.headerImgUrl!))
        }
        numTweetsLabel.text = "\(user.numTweets) Tweets"
        numFollowersLabel.text = "\(user.followersCount) Followers"
        numFollowingLabel.text = "\(user.friendsCount) Following"
        
        var tweetsVC = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as HomeViewController
        tweetsVC.user = user
        self.addChildViewController(tweetsVC)
        tweetsVC.view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        tweetsVC.view.frame = self.tweetsView.bounds
        self.tweetsView.addSubview(tweetsVC.view)
        tweetsVC.didMoveToParentViewController(self)
        
        navigationItem.title = user.displayName
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
