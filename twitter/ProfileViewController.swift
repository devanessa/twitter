//
//  ProfileViewController.swift
//  twitter
//
//  Created by vli on 10/4/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ProfileViewController: TimelineViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultHeight: CGFloat = 130
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        spinnerCellId = "spinnerCell2"
        retweetCellId = "retweetCell2"
        tweetCellId = "tweetCell2"
        
        if user!.headerImgUrl != nil {
            self.backgroundImgView.setImagewithURL(NSURL(string: user!.headerImgUrl!))
        }
        headerHeight.constant = defaultHeight
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 190))
        headerView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = headerView
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height)
        println("scrollview frame width: \(scrollView.frame.size.width), frame: \(self.view.frame.size.width)")
        var frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        
        var avatarView = UINib(nibName: "ProfileHeaderView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ProfileHeaderView
        avatarView.frame = frame
        avatarView.profileView.setImageWithURL(NSURL(string: user!.profileImgUrl))
        avatarView.handleLabel.text = "@\(user!.handle)"
        avatarView.handleLabel.textColor = UIColor.whiteColor()
        avatarView.bioLabel.hidden = true
        scrollView.addSubview(avatarView)
        
        var bioView = UINib(nibName: "ProfileHeaderView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ProfileHeaderView
        bioView.frame = frame
        bioView.frame.origin.x = self.view.frame.size.width
        bioView.profileView.hidden = true
        bioView.handleLabel.hidden = true
        bioView.bioLabel.text = user!.tagline
        bioView.bioLabel.textColor = UIColor.whiteColor()
        scrollView.addSubview(bioView)
        
        navigationItem.title = user!.displayName
        fetchTweets()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "tweetDetails") {
            var statusViewController = segue.destinationViewController as StatusViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            let tweet = tweets![indexPath!.row]
            
            statusViewController.tweet = tweet
            statusViewController.rowIndex = indexPath!.row
            
        } else if (segue.identifier == "composeSegue") {
            var composerVC = segue.destinationViewController as ComposerViewController
            
        }
        
    }

    override func handleTimelineRequest(tweets: [Tweet]?, error: NSError?) -> () {
        super.handleTimelineRequest(tweets, error: error)
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocityInView(scrollView.superview!)
        if scrollView.contentOffset.y <= 0 {
            self.view.bringSubviewToFront(scrollView)
            if velocity.y > 0 {
                // Scroll up return to normal size
                headerHeight.constant += -scrollView.contentOffset.y * (velocity.y/1000)
                
            } else if velocity.y < 0 {
                // Scroll down stretches image
                headerHeight.constant -= -scrollView.contentOffset.y * (-velocity.y/1000)
            }
        } else if scrollView.contentOffset.y > 0 {
            // This is to hide scrollview behind tableview
            println("bringing tableview to front")
            self.view.bringSubviewToFront(tableView)
        }
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < 0 {
            let duration = scrollView.contentOffset.y / UIScrollViewDecelerationRateNormal / 1000
            println("bringing scrollview to front")
            self.view.bringSubviewToFront(scrollView)
            UIView.animateWithDuration(Double(duration), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.headerHeight.constant = self.defaultHeight
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}
