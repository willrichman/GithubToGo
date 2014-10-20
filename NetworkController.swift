//
//  NetworkController.swift
//  GithubToGo
//
//  Created by William Richman on 10/20/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation

class NetworkController {
    
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

    func searchRepos(searchString: String, completionHandler: (repos: [Repo], errorDescription: String?) -> Void) {
        let url = NSURL(string: "127.0.0.1:3000")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
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
        })
        
        task.resume()
    }
}
