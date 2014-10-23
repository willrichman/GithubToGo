//
//  ProfileViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var reverseOrigin: CGRect?
    var image: UIImage?
    var selectedUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}
