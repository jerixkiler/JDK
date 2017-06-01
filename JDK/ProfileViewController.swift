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

    @IBAction func toogleGoTo(_ sender: Any) {
        
        performSegue(withIdentifier: "goToLogout", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIColor.white.cgColor]
        navigationController?.navigationItem.title = "Jeric John"
        
        
        coverImage.layer.shadowOpacity = 1
        coverImage.layer.shadowRadius = 6
        
    }
 
}
