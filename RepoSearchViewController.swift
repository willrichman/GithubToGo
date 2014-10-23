//
//  RepoSearchViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results = [Repo]()
    let searchType = NetworkController.SearchType.Repos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    //MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SEARCH_RESULT") as RepoCell
        cell.label.text = self.results[indexPath.row].name
        return cell
    }
    
    //MARK: - UISearchBarDelegate methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.activityIndicator.startAnimating()
        NetworkController.controller.search(searchBar.text, type: searchType, completionHandler: { (returnedArray, errorDescription) -> Void in
            self.results = returnedArray as [Repo]
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            searchBar.resignFirstResponder()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_REPO" {
            let destinationVC = segue.destinationViewController as? WebViewController
            
        }
    }
    
    
}
