//
//  StatusViewController.swift
//  twitter
//
//  Created by vli on 9/28/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, StatusPostDelegate {
    var tweet: Tweet!
    var mainTweet: Tweet!
    var rowIndex: Int!
    
    var delegate: StatusUpdateDelegate?
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var retweeted, favorited: Bool!
    
    let favoriteImg = UIImage(named: "favorite.png")
    let unfavoriteImg = UIImage(named: "unfavorite.png")
    let retweetedImg = UIImage(named: "retweeted.png")
    let retweetImg = UIImage(named: "retweet.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet.retweet == nil {
            setViewForTweet(tweet)
            mainTweet = tweet
        } else {
            setViewForTweet(tweet.retweet!)
            mainTweet = tweet.retweet!
        }
        
        favorited = mainTweet.favorited
        updateFavorited()
        
        retweeted = mainTweet.retweeted
        updateRetweeted()
        
        statusView.layer.cornerRadius = 15
        statusView.layer.borderWidth = 1.0
        statusView.layer.borderColor = UIColor(white: 0.85, alpha: 0.7).CGColor
        statusView.clipsToBounds = true
    }
    
    func setViewForTweet(tweet: Tweet) {
        displayNameLabel.text = "\(tweet.user.displayName)"
        handleLabel.text = "\(tweet.user.handle)"
        profileImageView.setProfileImageWithURL(NSURL(string: tweet.user.profileImgUrl))
        statusLabel.text = "\(tweet.text)"
        dateLabel.text = "\(tweet.date.toPrettyString(simple: false))"
        retweetCount.text = "\(tweet.retweetCount)"
        favoritesCount.text = "\(tweet.favoritesCount)"
    }
    
    @IBAction func replyToTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("replySegue", sender: self)
    }
    
    @IBAction func toggleRetweet(sender: AnyObject) {
        retweeted = !retweeted
        updateRetweeted(toggle: true)
    }
    
    @IBAction func toggleFavorite(sender: AnyObject) {
        favorited = !favorited
        updateFavorited(toggle: true)
    }
    
    func updateRetweeted(toggle: Bool = false) {
        if retweeted! {
            retweetButton.setImage(retweetedImg, forState: .Normal)
            if toggle {
//                mainTweet.postRetweet()
                retweetCount.text = "\(mainTweet.retweetCount + 1)"
            }
        } else {
            retweetButton.setImage(retweetImg, forState: .Normal)
            if toggle {
                retweetCount.text = "\(mainTweet.retweetCount)"
            }
        }
    }
    
    func updateFavorited(toggle: Bool = false) {
        if favorited! {
            favoriteButton.setImage(favoriteImg, forState: .Normal)
            if toggle {
                favoritesCount.text = "\(mainTweet.favoritesCount + 1)"
            }
        } else {
            favoriteButton.setImage(unfavoriteImg, forState: .Normal)
            if toggle {
                favoritesCount.text = "\(mainTweet.favoritesCount)"
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "replySegue") {
            var composerViewController = segue.destinationViewController as ComposerViewController
            composerViewController.tweetToReply = mainTweet
            composerViewController.delegate = self
        }
    }
    
    func didPostTweet(tweet: Tweet) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.didPostReply(tweet)
    }
}
