//
//  RepoSearchViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.controller.searchRepos("Tetris", completionHandler: { (repos, errorDescription) -> Void in
            self.results = repos
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SEARCH_RESULT") as UITableViewCell
        cell.textLabel?.text = results[indexPath.row].name
        return cell
    }


}
