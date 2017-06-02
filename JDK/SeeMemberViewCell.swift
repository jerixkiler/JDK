//
//  SeeMemberViewCell.swift
//  JDK
//
//  Created by Nexusbond on 01/06/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit

class SeeMemberViewCell: UITableViewCell {

    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var displayNameText: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
    }
}
