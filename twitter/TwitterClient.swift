//
//  TwitterClient.swift
//  twitter
//
//  Created by vli on 9/26/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

let twitterConsumerKey = "TeAvUbvH2QfqHEO7yViiZSr4v"
let twitterConsumerSecret = "EpGeGDVyh7nP2ASTlumANJlb3VIItczZtWxyjt55X3zTGCYxXb"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting tweets: \(error)")
            completion(tweets: nil, error: error)
        })

    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                
                // persist User
                User.currentUser = user
                println("user: \(user.displayName)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                })
            }, failure: { (error: NSError!) -> Void in
                println("failed to get the access token!")
                self.loginCompletion?(user: nil, error: error)
        })

    }
    
    // Actions user can perform on tweets
    func postTweet(status: String, params: [String: String]?, completion: (response: Tweet?, error: NSError?) -> ()) {
        var parameters = ["status": status]
        if params != nil {
            parameters += params!
        }
        POST("1.1/statuses/update.json", parameters: parameters, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Failed to post tweet")
            completion(response: nil, error: error)
        })
    }
    
    func replyToTweet(reply: String, id_to_reply: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        var parameters = ["in_reply_to_status_id": "\(id_to_reply)"]
        postTweet(reply, params: parameters) { (response, error) -> () in
            completion(response: response, error: error)
        }
    }
    
    func favoriteTweetWithId(tweetId: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json", parameters: ["id": tweetId], success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to favorite tweet \(tweetId)")
                completion(response: nil, error: error)
        })
    }
    
    func unfavoriteTweetWithId(tweetId: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json", parameters: ["id": tweetId], success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to unfavorite tweet \(tweetId)")
                completion(response: nil, error: error)
        })
    }
    
    func retweetWithId(tweetId: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json", parameters: ["id": tweetId], success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to favorite tweet \(tweetId)")
                completion(response: nil, error: error)
        })
    }
    
    func unfavoriteTweetWithCompletion(tweetId: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json", parameters: ["id": tweetId], success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to unfavorite tweet \(tweetId)")
                completion(response: nil, error: error)
        })
    }
    
    func deleteTweet(tweetIdStr: String, completion: (response: Tweet?, error: NSError?) -> ()) {
        POST("/1.1/statuses/destroy/\(tweetIdStr).json", parameters: nil, success: {( operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as NSDictionary)
            completion(response: tweet, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Failed to delete tweet \(tweetIdStr)")
            completion(response: nil, error: error)
        })
    }
    
}
