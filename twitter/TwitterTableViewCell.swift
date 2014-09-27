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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCellFromStatus(status: Status) {
        displayNameLabel.text = status.user.displayName
        tweetLabel.text = status.text
        twitterHandleLabel.text = "@\(status.user.handle)"  // make this attributed?
        userImageView.setImageWithURL(NSURL(string: status.user.profileImgUrl))
        UIView.animateWithDuration(0.2, animations: {
            self.userImageView.alpha = 1.0
        })
    }

}

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populateCellFromStatus(status: Status) {
        let retweetStatus = status.retweet!
        displayNameLabel.text = retweetStatus.user.displayName
        retweetLabel.text = retweetStatus.text
        twitterHandleLabel.text = "@\(retweetStatus.user.handle)"  // make this attributed?
        retweeterLabel.text = "\(status.user.displayName) retweeted"
        userImageView.setImageWithURL(NSURL(string: retweetStatus.user.profileImgUrl))
        UIView.animateWithDuration(0.2, animations: {
            self.userImageView.alpha = 1.0
        })
    }
}