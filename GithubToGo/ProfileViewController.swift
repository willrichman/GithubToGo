//
//  ProfileViewController.swift
//  GithubToGo
//
//  Created by William Richman on 10/22/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var reverseOrigin: CGRect?
    var image: UIImage?
    var selectedUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if selectedUser == nil {
            NetworkController.controller.fetchCurrentUser({ (user, errorDescription) -> Void in
                self.selectedUser = user!
                if let userImage = self.selectedUser!.avatarImage {
                    self.imageView.image = userImage
                } else {
                    NetworkController.controller.getAvatar(self.selectedUser!.avatarURL!, completionHandler: { (image, errorDescription) -> Void in
                        self.imageView.image = image
                        self.selectedUser!.avatarImage = image
                        self.login.text = self.selectedUser?.login
                    })
                }
            })
        } else {
            self.login.text = self.selectedUser?.login
        }
        
    }

    
}
