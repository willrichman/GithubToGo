//
//  ShowUserAnimator.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ShowUserAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    var selectedCell : UICollectionViewCell?

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Find references for the two views controllers we're moving between
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ProfileViewController
        
        // Grab the container view from the context
        let containerView = transitionContext.containerView()
        
        //start the toVC offscreen to the right
        toViewController.view.frame = containerView.frame
        toViewController.view.frame.origin = CGPoint(x: toViewController.view.frame.width, y:toViewController.view.frame.origin.y)
        containerView.addSubview(toViewController.view)
        toViewController.imageView.hidden = true
        
        // Add the toViewController's view onto the containerView
        containerView.addSubview(toViewController.view)
        
        //generate our moving image view
        let userCell = selectedCell as UserCell
        let startFrame = fromViewController.collectionView.convertPoint(userCell.frame.origin, toView: fromViewController.view)
        var temporaryMovingImage = UIImageView(frame:CGRect(x: startFrame.x, y: startFrame.y, width: userCell.frame.width, height: userCell.frame.height))
        temporaryMovingImage.clipsToBounds = true
        temporaryMovingImage.image = userCell.userImage.image
        containerView.addSubview(temporaryMovingImage)
        userCell.hidden = true
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            toViewController.view.frame.origin = fromViewController.view.frame.origin
            
            println(containerView.frame)
            println(CGRectGetMidX(containerView.frame))
            
            var finalSize = UIScreen.mainScreen().bounds.width - 40
            var finalX = CGRectGetMidX(toViewController.view.bounds) - (finalSize * 0.5)
            println(containerView.frame)
            println(toViewController.view.frame)
            var finalY = toViewController.imageView.frame.origin.y + 60
            
            var finalWidth = toViewController.imageView.frame.width
            var finalHeight = toViewController.imageView.frame.height
            
            temporaryMovingImage.frame = CGRect(x: finalX, y: finalY, width: finalSize, height: finalSize)
            
            }) { (finished) -> Void in
                
                toViewController.imageView.image = temporaryMovingImage.image
                toViewController.imageView.hidden = false
                temporaryMovingImage.removeFromSuperview()
                userCell.hidden = false
                transitionContext.completeTransition(true)
                
        }
    }

    
}
