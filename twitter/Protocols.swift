//
//  StatusUpdateDelegate.swift
//  twitter
//
//  Created by vli on 9/29/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

protocol StatusUpdateDelegate {
    func didPostTweet(tweet: Tweet)
}
