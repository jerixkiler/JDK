//
//  ProfileViewController.swift
//  JDK
//
//  Created by Nexusbond on 31/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
//        navigationItem.title = "Jeric John Carillo"
//        navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 129/255, green: 215/255, blue: 251/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIColor.white.cgColor]
        
//        navigationController?.navigationBar.barStyle = .default
        
    }
 
}
