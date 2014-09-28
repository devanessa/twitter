//
//  Tweet.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString
    var retweet: Tweet?
    var dateString: String?
    var date: NSDate
    var user: User
    
    
    init(dictionary: NSDictionary) {
        // set your own properties before calling super()!
        self.text = dictionary["text"] as NSString
        
        let userDict = dictionary["user"] as NSDictionary
        self.user = User(dictionary: userDict)        
        let possibleRetweet = dictionary["retweeted_status"] as? NSDictionary
        if possibleRetweet != nil {
            self.retweet = Tweet(dictionary: possibleRetweet!)
        }
        
        dateString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.date = formatter.dateFromString(dateString!)!
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
