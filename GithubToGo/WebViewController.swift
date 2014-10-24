//
//  WebViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/23/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var repoToView : Repo?
    let baseURL = "https://github.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        var newOrigin = CGPoint(x: self.view.frame.origin.x, y: 20)
        var newSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 20)
        
        self.webView.frame = CGRect(origin: newOrigin, size: newSize)
        if let urlToShow = NSURL(string: (baseURL + repoToView!.name)) {
            self.webView.loadRequest(NSURLRequest(URL: urlToShow))
        }
        else {
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.google.com/")!))
        }
    }
    
    

}
