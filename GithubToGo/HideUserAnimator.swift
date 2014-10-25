//
//  HideUserAnimator.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class HideUserAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    var selectedCell : UICollectionViewCell?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Find references for the two views controllers we're moving between
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ProfileViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserSearchViewController
        
        // Grab the container view from the context
        let containerView = transitionContext.containerView()
        

        
        // Add the toViewController's view onto the containerView
        containerView.addSubview(toViewController.view)
        
        //generate our moving image view
        let userCell = selectedCell as UserCell
        
        var temporaryMovingImage = UIImageView(frame:fromViewController.imageView.frame)
        temporaryMovingImage.clipsToBounds = true
        temporaryMovingImage.image = fromViewController.imageView.image
        containerView.addSubview(temporaryMovingImage)
        userCell.hidden = true
        fromViewController.imageView.hidden = true
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            fromViewController.view.frame.origin = CGPoint(x: toViewController.view.frame.width, y:toViewController.view.frame.origin.y)
            
            let finalOrigin = toViewController.collectionView.convertPoint(userCell.frame.origin, toView: toViewController.view)
            //start the toVC offscreen to the right
            
            temporaryMovingImage.frame = CGRect(origin: finalOrigin, size: userCell.userImage.frame.size)
            
            }) { (finished) -> Void in
                
                temporaryMovingImage.removeFromSuperview()
                userCell.hidden = false
                transitionContext.completeTransition(true)
                
        }
    }


    
}
