//
//  User.swift
//  JDK
//
//  Created by Nexusbond on 30/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import Firebase


class User {

    var userUID: String
    var userEmailAddress: String
    var userFullname: String
    var profileUrl: String
    
    init(userUID: String , userEmailAddress: String, userFullname: String , profileUrl: String ) {
        self.userUID = userUID
        self.userEmailAddress = userEmailAddress
        self.userFullname = userFullname
        self.profileUrl = profileUrl
    }
    
}

