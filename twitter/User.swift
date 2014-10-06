//
//  User.swift
//  twitter
//
//  Created by vli on 9/27/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

var _userAccounts: [User]?
var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var displayName, handle, profileImgUrl, tagline: String
    var dictionary: NSDictionary
    var favoritesCount, followersCount, friendsCount, numTweets: Int
    var headerImgUrl: String?
    
    init(dictionary: NSDictionary) {
        self.displayName = dictionary["name"] as String
        self.profileImgUrl = dictionary["profile_image_url"] as String
        self.headerImgUrl = dictionary["profile_banner_url"] as? String
        self.handle = dictionary["screen_name"] as String
        self.tagline = dictionary["description"] as String
        self.favoritesCount = dictionary["favourites_count"] as Int
        self.followersCount = dictionary["followers_count"] as Int
        self.friendsCount = dictionary["friends_count"] as Int
        self.numTweets = dictionary["statuses_count"] as Int
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func addUserAccount(user) {
        // add a user account to _userAccounts
    }
    
    class func removeUserAccount(user) {
        // remove user from account
    }
    
//    func getProfileBanner(completion: (response: String?, error: NSError?) -> ()) {
//        TwitterClient.sharedInstance.getUserBanner(self.handle, completion: completion)
//    }
}
