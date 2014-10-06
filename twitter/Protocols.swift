//
//  StatusUpdateDelegate.swift
//  twitter
//
//  Created by vli on 9/29/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

protocol StatusPostDelegate {
    func didPostTweet(tweet: Tweet)
}
protocol StatusUpdateDelegate {
    func didUpdateDataAtRow(row: Int, tweet: Tweet)
    func didPostReply(tweet: Tweet)
}
protocol ProfileImageTappedDelegate {
    func didTapProfileImg(user: User)
}