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
    
    func searchRepos(searchString: String, completionHandler: (repos: [Repo], errorDescription: String?) -> Void) {
        let searchReposURL = "https://api.github.com/search/repositories?q="
        let url = NSURL(string: (searchReposURL + searchString))
        
        let task = self.networkSession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if error != nil {
                    // If there is an error in the web request, print to console
                    println(error.localizedDescription)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    println("Success!!")
                    let repos = Repo.parseJSONDataIntoRepos(data)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(repos: repos!, errorDescription: nil)
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
    
}
