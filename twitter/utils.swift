//
//  utils.swift
//  twitter
//
//  Created by vli on 9/28/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

extension UIImageView {
    func setProfileImageWithURL(url: NSURL, animate: Bool = false) {
        self.setImageWithURL(url)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
        self.clipsToBounds = true
        if animate {
            UIView.animateWithDuration(0.2, animations: {
                self.alpha = 1.0
            })
        }
    }
}

let secondsInMin: NSTimeInterval = 60
let minInHours: NSTimeInterval = 60
let hoursInDay: NSTimeInterval = 24

extension NSDate {
    func toPrettyString(simple: Bool = true) -> String {
        if simple {
            let pastInSeconds = -(self.timeIntervalSinceNow)
            
            if pastInSeconds < secondsInMin {
                return "\(pastInSeconds)s"
            } else if pastInSeconds < secondsInMin * minInHours {
                let minutes = Int(pastInSeconds / secondsInMin)
                return "\(minutes)m"
            } else if pastInSeconds < secondsInMin * minInHours * hoursInDay {
                let hours = Int(pastInSeconds / (secondsInMin * minInHours))
                return "\(hours)h"
            } else {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMM dd"
                return formatter.stringFromDate(self)
            }
        } else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd, YYYY - h:mm a"
            return formatter.stringFromDate(self)
        }
    }
}