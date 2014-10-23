//
//  NetworkController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    
    let clientID = "client_id=9595767a53c6abe8f160"
    let clientSecret = "client_secret=104001e1fc01241faeeb6ddf5d9c218a268d89cf"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=githubtogo://test"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
    var networkSession : NSURLSession?
    var oAuthToken : String?
    
    enum SearchType {
        case Repos, Users, Error
    }
    
    class var controller: NetworkController {
    struct Static {
        static var onceToken : dispatch_once_t = 0
        static var instance : NetworkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
    
    init() {

        let key = "OAuthToken"
        if let oAuthToken = NSUserDefaults.standardUserDefaults().valueForKey(key) as? String {
            println("Found saved OAuthToken")
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let tokenKey : NSString = "token \(oAuthToken)"
            configuration.HTTPAdditionalHeaders = ["Authorization": tokenKey]
            self.networkSession = NSURLSession(configuration: configuration)
            
        } else {
            println("No Saved OAuthToken")
            let authAlert = UIAlertController(title: "Authorize", message: "We need to take you to GitHub to log in to your account", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.requestOAuthAccess()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            })
            
        }
    
    }
    
    //MARK: - OAuth functions
    
    func requestOAuthAccess() {
        /* Take user from our app to GitHub to request access */
        let url = githubOAuthURL + clientID + "&" + scope + "&" + redirectURL
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

    func handleOAuthURL(callbackURL : NSURL) {
        let query = callbackURL.query
        println(query)
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        
        // Construct the query string for the final POST call
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: self.githubPOSTURL)!)
        request.HTTPMethod = "POST"
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        println(tokenResponse!)
                        let responseComponents = tokenResponse?.componentsSeparatedByString("&")
                        self.oAuthToken = responseComponents?.first?.componentsSeparatedByString("access_token=").last as? String
                        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        let tokenKey : NSString = "token \(self.oAuthToken!)"
                        configuration.HTTPAdditionalHeaders = ["Authorization": tokenKey]
                        self.networkSession = NSURLSession(configuration: configuration)
                        
                        let key = "OAuthToken"
                        NSUserDefaults.standardUserDefaults().setValue(self.oAuthToken, forKey: key)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    default:
                        println("default case on status code")
                        println(httpResponse.statusCode)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    //MARK: - Data fetch functions
    
    func search (searchString: String, type: SearchType, completionHandler: (returnedArray: [AnyObject]?, errorDescription: String?) -> Void) {
        let searchReposURL = "https://api.github.com/search/repositories?q="
        let searchUsersURL = "https://api.github.com/search/users?q="
        let cleanedSearch = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
        var url : NSURL?
        switch type {
        case .Repos:
            url = NSURL(string: (searchReposURL + cleanedSearch))?
        case .Users:
            url = NSURL(string: (searchUsersURL + cleanedSearch))?
        default:
            println("That is not a valid search type")
        }
        
        let task = self.networkSession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if error != nil {
                    // If there is an error in the web request, print to console
                    println(error.localizedDescription)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    println("Success!!")
                    var returnedArray : [AnyObject]?
                    switch type {
                    case .Repos:
                        returnedArray = Repo.parseJSONDataIntoRepos(data)
                    case .Users:
                        returnedArray = User.parseJSONDataIntoUsers(data)
                    default:
                        println("Something bad happened")
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(returnedArray: returnedArray, errorDescription: nil)
                    })
                case 400...499:
                    println("error on the client")
                    println(httpResponse.description)
                    
                case 500...599:
                    println("error on the server")
                default:
                    println("something bad happened")
                }
            }
            else {
                println("Something bad happened")
            }
        })
        
        task.resume()
    }
    
    //MARK: - UI Fetch functions
    
    func getAvatar(avatarURL: String, completionHandler: (image: UIImage?, errorDescription: String?) -> Void) {
        let url = NSURL(string: avatarURL)
        let task = self.networkSession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if error != nil {
                    // If there is an error in the web request, print to console
                    println(error.localizedDescription)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    if let avatarImage = UIImage(data: data) {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(image: avatarImage, errorDescription: nil)
                        })
                    }
                case 400...499:
                    println("error on the client")
                    println(httpResponse.description)
                    
                case 500...599:
                    println("error on the server")
                default:
                    println("something bad happened")
                }
            }
        })
        
        task.resume()
    }
    
}
