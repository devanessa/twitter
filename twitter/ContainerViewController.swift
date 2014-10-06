//
//  ContainerViewController.swift
//  twitter
//
//  Created by vli on 10/4/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var sideBarTableView: UITableView!
    
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    var sideBarNames: [String] = ["Home", "Mentions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rightSwipeGestureRecognizer.direction = .Right
        self.leftSwipeGestureRecognizer.direction = .Left
        self.xConstraint.constant = 0
        
        let currentUser = User.currentUser
        displayNameLabel.text = currentUser!.displayName
        profileImgView.setProfileImageWithURL(NSURL(string: currentUser!.profileImgUrl))
        
        self.sideBarTableView.delegate = self
        self.sideBarTableView.dataSource = self
        
        let timelineVC = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as HomeViewController
        timelineVC.apiType = .Timeline
        
        let mentionsVC = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as HomeViewController
        mentionsVC.apiType = .Mentions
        
        viewControllers = [timelineVC, mentionsVC]
        
        self.activeViewController = viewControllers.first
        navigationItem.title = sideBarNames.first
    }

    @IBAction func logoutUser(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: {
                if sender.direction == .Right {
                    self.xConstraint.constant = -160
                } else if sender.direction == .Left {
                    self.xConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func didTapProfileImg(sender: UIButton) {
        let profileVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        profileVC.user = User.currentUser
        
        self.activeViewController = profileVC
        navigationItem.title = "Me"
        UIView.animateWithDuration(0.2, animations: {
            self.xConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeViewController = viewControllers[indexPath.row]
        navigationItem.title = sideBarNames[indexPath.row]
        UIView.animateWithDuration(0.35, animations: {
            self.xConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sideBarCell") as sideBarTableViewCell
        cell.viewName.text = sideBarNames[indexPath.row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
