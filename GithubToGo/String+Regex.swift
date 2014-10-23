//
//  StringExtension.swift
//  GithubToGo
//
//  Created by William Richman on 10/23/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation

extension String {
    func validate() -> Bool {
        var regex = NSRegularExpression(pattern: "[^0-9a-zA-Z \n]", options: nil, error: nil)
        let match = regex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
        if match > 0 {
            return false
        }
        return true
    }
}