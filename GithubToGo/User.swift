//
//  User.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation
import UIKit

class User {
    var login : String?
    var avatarURL : String?
    var avatarImage : UIImage?
    
    init (login: String, avatarURL : String) {
        self.login = login
        self.avatarURL = avatarURL
    }
    
    class func parseJSONDataIntoUsers(rawJSONData : NSData) -> [User]? {
        
        /* Generic error for JSONObject error protocol */
        var error : NSError?
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            /* Empty array for users */
            var users = [User]()
            if let searchResultsArray = JSONDictionary["items"] as? NSArray {
                for result in searchResultsArray {
                    if let resultDictionary = result as? NSDictionary {
                        let resultName = resultDictionary["login"] as String
                        let resultURL = resultDictionary["avatar_url"] as String
                        let newUser = User(login: resultName, avatarURL: resultURL)
                        users.append(newUser)
                    }
                }
            }
            return users
        }
        
        return nil
    }
    
}