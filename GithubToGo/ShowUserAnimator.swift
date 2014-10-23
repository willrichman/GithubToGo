//
//  ShowUserAnimator.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ShowUserAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    // Rectangle denoting where the animation should start from
    // Used for positioning the toViewController's view
    var origin: CGRect?

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Find references for the two views controllers we're moving between
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ProfileViewController
        
        // Grab the container view from the context
        let containerView = transitionContext.containerView()
        
        // Position the toViewController in it's starting position
        toViewController.view.frame = self.origin!
        toViewController.imageView.frame = self.origin!
        
        // Add the toViewController's view onto the containerView
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            // During animation, expand the toViewController's view frame
            // to match the original view controllers
            // This will cause the toViewController to fill the screen
            toViewController.view.frame = fromViewController.view.frame
            }) { (finished) -> Void in
                // When finished, hide our fromViewController
                fromViewController.view.alpha = 0.0
                // And tell the transitionContext we're done
                transitionContext.completeTransition(finished)
        }
    }

    
}
