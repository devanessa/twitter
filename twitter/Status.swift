//
//  Status.swift
//  twitter
//
//  Created by vli on 9/24/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class Status: NSObject {
    var text: NSString
//    var profileImgUrl: NSString
    var retweet: Status?
    var date: NSDate
    var user: User
    
    
    init(dictionary: NSDictionary) {
        // set your own properties before calling super()!
        self.text = dictionary["text"] as NSString
        
        let userDict = dictionary["user"] as NSDictionary
        self.user = User(dictionary: userDict)        
        let possibleRetweet = dictionary["retweeted_status"] as? NSDictionary
        if possibleRetweet != nil {
            self.retweet = Status(dictionary: possibleRetweet!)
        }
        
        self.date = NSDate.date()
//        let dateString = dictionary["created_at"] as NSString
//        var error: NSError? = nil
//        var dataDetector = NSDataDetector(types: NSTextCheckingType.Link.toRaw(), error: &error)
//        var matches = dataDetector.matchesInString(dateString, options: NSMatchingOptions(0), range: NSMakeRange(0, dateString.length))
//        for match in matches {
//            
//        }
//        dataDetector.enumerateMatchesInString(dateString, options: NSRegularExpressionOptions(0), range: 0..dateString.length, usingBlock: <#(NSTextCheckingResult!, NSMatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void##(NSTextCheckingResult!, NSMatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void#>)
//        dateFormatter.dateFormat = "dd-MM-yyyy"
        // voila!
//        var dateFromString = dateFormatter.dateFromString(dateString)
    }
}
