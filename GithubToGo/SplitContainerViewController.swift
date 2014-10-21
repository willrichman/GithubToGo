//
//  SplitContainerViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {
    
    var menuVC : MenuTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
        let navVC = splitVC.viewControllers[0] as UINavigationController
        self.menuVC = navVC.viewControllers[0] as MenuTableViewController
        
        let key = "OAuthToken"
        if let oAuthToken = NSUserDefaults.standardUserDefaults().valueForKey(key) as? String {
            println("Found saved OAuthToken")
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let tokenKey : NSString = "token \(oAuthToken)"
            configuration.HTTPAdditionalHeaders = ["Authorization": tokenKey]
            NetworkController.controller.networkSession = NSURLSession(configuration: configuration)

        } else {
            println("No Saved OAuthToken")
            dispatch_after(1, dispatch_get_main_queue(), {
                NetworkController.controller.requestOAuthAccess()
            })
        }
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        if self.menuVC.firstLaunch == true {
            self.menuVC.firstLaunch = false
            return true
        }
        return false
    }
}
