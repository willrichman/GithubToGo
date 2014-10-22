//
//  UserSearchViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userResults = [User]()
    let searchType = NetworkController.SearchType.Users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.collectionView.dataSource = self

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        var userForCell = userResults[indexPath.row] as User
        cell.label.text = userForCell.login
        if let userImage = userForCell.avatarImage {
            cell.userImage.image = userImage
        }
        return cell
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NetworkController.controller.search(searchBar.text, type: searchType, completionHandler: { (returnedArray, errorDescription) -> Void in
            self.userResults = returnedArray as [User]
            self.collectionView.reloadData()
            searchBar.resignFirstResponder()
        })
    }
}
