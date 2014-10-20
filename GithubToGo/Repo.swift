//
//  Repo.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation

class Repo {
    var name : String
    var url : String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    class func parseJSONDataIntoRepos(rawJSONData : NSData) -> [Repo]? {
        
        /* Generic error for JSONObject error protocol */
        var error : NSError?
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            /* Empty array for repos */
            var repos = [Repo]()
            if let searchResultsArray = JSONDictionary["items"] as? NSArray {
                for result in searchResultsArray {
                    if let resultDictionary = result as? NSDictionary {
                        let resultName = resultDictionary["full_name"] as String
                        let resultURL = resultDictionary["html_url"] as String
                        let newRepo = Repo(name: resultName, url: resultURL)
                        repos.append(newRepo)
                    }
                }
            }
            return repos
        }
        return nil
    }
}