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
    var identifier: String
    var favoritesCount, retweetCount: Int
    var favorited, retweeted: Bool
    
    init(dictionary: NSDictionary) {
        // set your own properties before calling super()!
        self.identifier = dictionary["id_str"] as NSString
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
        
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        retweeted = dictionary["retweeted"] as? Bool ?? false
        
        favoritesCount = dictionary["favourites"] as? Int ?? 0 // are you kidding me?
        favorited = dictionary["favorited"] as? Bool ?? false
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    // compose tweet
    class func postTweet(status: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.postTweet(status, params: nil, completion: completion)
    }

    // retweet
    func postRetweet() -> Tweet? {
        var tweet: Tweet?
        TwitterClient.sharedInstance.retweetWithId(self.identifier) { (response, error) -> () in
            if response != nil {
                tweet = response
            }
        }
        return tweet
    }
    
    // reply to tweet
    func replyToTweet(response: String) -> Tweet? {
        var tweet: Tweet?
        TwitterClient.sharedInstance.replyToTweet(response, id_to_reply: self.identifier) { (response, error) -> () in
            if response != nil {
                tweet = response
            }
        }
        return tweet
    }
    
    // delete tweet
    func deleteTweet() -> Tweet? {
        var tweet: Tweet?
        TwitterClient.sharedInstance.deleteTweet(self.identifier) { (response, error) -> () in
            if response != nil {
                tweet = response
            }
        }
        return tweet
    }
    
    // favorite tweet (can you favorite your own tweet? yes.)
    func favoriteTweet() -> Tweet? {
        var tweet: Tweet?
        TwitterClient.sharedInstance.favoriteTweetWithId(self.identifier) { (response, error) -> () in
            if response != nil {
                tweet = response
            }
        }
        return tweet
    }
}
