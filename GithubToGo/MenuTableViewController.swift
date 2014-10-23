//
//  MenuTableViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var firstLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = self.navigationController {
            navController.delegate = self
        }
        
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This is called whenever during all navigation operations
        
        // Only return a custom animator for two view controller types
        if let userSearchViewController = fromVC as? UserSearchViewController {
            if let profileViewController = toVC as? ProfileViewController {
                let animator = ShowUserAnimator()
                animator.origin = userSearchViewController.origin
                animator.selectedCell = userSearchViewController.selectedCell
                
                return animator
            }
        }
        
        else if let profileViewController = fromVC as? ProfileViewController {
            if let userSearchViewController = toVC as? UserSearchViewController {
                let animator = HideUserAnimator()
                animator.origin = profileViewController.reverseOrigin
                animator.selectedCell = userSearchViewController.selectedCell
                
                return animator
            }
        }
        
        // All other types use default transition
        return nil
    }

}
