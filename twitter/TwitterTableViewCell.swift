//
//  twitterTableViewCell.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var user: User?
    
    var delegate: ProfileImageTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapProfileImg(sender: UIButton) {
        delegate?.didTapProfileImg(user!)
    }
    
    func populateCellFromTweet(tweet: Tweet) {
        user = tweet.user
        displayNameLabel.text = tweet.user.displayName
        tweetLabel.text = tweet.text
        twitterHandleLabel.text = "@\(tweet.user.handle)"  // make this attributed?
        userImageView.setProfileImageWithURL(NSURL(string: tweet.user.profileImgUrl), animate: true)
        dateLabel.text = tweet.date.toPrettyString()
    }

}

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var user: User?
    
    var delegate: ProfileImageTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTapProfileImg(sender: UIButton) {
        delegate?.didTapProfileImg(user!)
    }
    
    func populateCellFromTweet(tweet: Tweet) {
        let retweetStatus = tweet.retweet!
        user = retweetStatus.user
        displayNameLabel.text = retweetStatus.user.displayName
        retweetLabel.text = retweetStatus.text
        twitterHandleLabel.text = "@\(retweetStatus.user.handle)"  // make this attributed?
        retweeterLabel.text = "\(tweet.user.displayName) retweeted"
        userImageView.setProfileImageWithURL(NSURL(string: retweetStatus.user.profileImgUrl))
        dateLabel.text = tweet.date.toPrettyString()
    }
    
}