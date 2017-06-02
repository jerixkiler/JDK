//
//  ChatMembers.swift
//  JDK
//
//  Created by Nexusbond on 02/06/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit

class ChatMembers {

    
    var memberImageUrl: String?
    var memberDisplayName: String?
    var memberStatus: String?
    
    init(memberImageUrl: String , memberDisplayName: String , memberStatus: String) {
        self.memberImageUrl = memberImageUrl
        self.memberDisplayName = memberDisplayName
        self.memberStatus = memberStatus
    }
    
}
