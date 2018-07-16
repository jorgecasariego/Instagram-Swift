//
//  FirebaseUtils.swift
//  Intagram
//
//  Created by Jorge Casariego on 16/7/18.
//  Copyright © 2018 Jorge Casariego. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (error) in
            print("Failed to fetch user for posts: ", error)
        }
    }
}
