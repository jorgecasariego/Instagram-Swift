//
//  User.swift
//  Intagram
//
//  Created by Jorge Casariego on 16/7/18.
//  Copyright © 2018 Jorge Casariego. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
