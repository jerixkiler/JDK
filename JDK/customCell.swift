//
//  customCell.swift
//  JDK
//
//  Created by Nexusbond on 31/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit

class customCell: UICollectionViewCell {
    
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var topicDescriptionLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var joinButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeItCircle()
    }
    
    func makeItCircle() {
        self.backgroundImageView.layer.masksToBounds = true
        self.backgroundImageView.layer.cornerRadius  = CGFloat(roundf(Float(self.backgroundImageView.frame.size.width/2.0)))
    }
    
    
    
    
}
