//
//  User.swift
//  twitter
//
//  Created by vli on 9/27/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class User: NSObject {
   var displayName, handle, profileImgUrl: NSString
    
    init(dictionary: NSDictionary) {
        self.displayName = dictionary["name"] as NSString
        self.profileImgUrl = dictionary["profile_image_url"] as NSString
        self.handle = dictionary["screen_name"] as NSString
    }
}
