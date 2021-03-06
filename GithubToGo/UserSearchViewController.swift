//
//  UserSearchViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userResults = [User]()
    let searchType = NetworkController.SearchType.Users
    
    var selectedCell : UICollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
    //MARK: - UICollectionViewDataSource Methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        var userForCell = userResults[indexPath.row] as User
        cell.userImage.image = nil
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        cell.label.text = userForCell.login
        if let userImage = userForCell.avatarImage {
            if cell.tag == currentTag {
                cell.userImage.image = userImage
            }
        } else {
            NetworkController.controller.getAvatar(userForCell.avatarURL!, completionHandler: { (image, errorDescription) -> Void in
                if cell.tag == currentTag {
                    cell.userImage.image = image
                    userForCell.avatarImage = image
                }
            })
        }
        return cell
    }

    //MARK: - UICollectionViewDelegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Find tapped image, initialize next view controller
        let image = self.userResults[indexPath.row % self.userResults.count].avatarImage!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        
        // Set image and reverseOrigin properties on next view controller
        viewController.image = image
        let user = self.userResults[indexPath.row]
        viewController.selectedUser = user
        
        self.selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath)
        
        // Trigger a normal push animations; let navigation controller take over.
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NetworkController.controller.search(searchBar.text, type: searchType, completionHandler: { (returnedArray, errorDescription) -> Void in
            self.userResults = returnedArray as [User]
            self.collectionView.reloadData()
            searchBar.resignFirstResponder()
        })
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var warningRect = CGRect(x: 37, y: 114, width: 300, height: 40)
        var warningLabel = UILabel()
        warningLabel.frame = warningRect
        warningLabel.backgroundColor = UIColor.redColor()
        warningLabel.textColor = UIColor.whiteColor()
        warningLabel.textAlignment = NSTextAlignment.Center
        warningLabel.layer.cornerRadius = 8
        warningLabel.clipsToBounds = true
        warningLabel.alpha = 0
        warningLabel.text = "Search does not support character '\(text)'"
        
        
        if text.validate() == false {
            view.addSubview(warningLabel)
            UIView.animateWithDuration(0.8, delay: 0.0, options: nil, animations: { () -> Void in
                warningLabel.alpha = 1.0
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.8, delay: 2.0, options: nil, animations: { () -> Void in
                        warningLabel.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            
                    })
            })
        }
        return text.validate()
    }
    
}
