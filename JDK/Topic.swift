//
//  Topic.swift
//  JDK
//
//  Created by Nexusbond on 30/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit

class Topic {

    var ownerUserID: String?
    var photoBackgroundUrl: String?
    var timeCreated: Double?
    var topicDescription: String?
    
    
    init(ownerUserID: String , photoBackgroundUrl: String , timeCreated: Double, topicDescription: String) {
        self.ownerUserID = ownerUserID
        self.photoBackgroundUrl = photoBackgroundUrl
        self.timeCreated = timeCreated
        self.topicDescription = topicDescription
    }

    
}
