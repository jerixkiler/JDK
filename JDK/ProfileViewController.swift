//
//  ProfileViewController.swift
//  JDK
//
//  Created by Nexusbond on 31/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import GoogleSignIn
class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var blurryView: UIView!
    @IBOutlet weak var lblName: UILabel!

    
    var UID: String = (Auth.auth().currentUser?.uid)!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseRef = Database.database().reference()
        
        
    }
    
    @IBAction func toogleLogout(_ sender: Any) {
        
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        
        dismiss(animated: true, completion: nil)
    
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
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIColor.white.cgColor]
        navigationController?.navigationItem.title = "Jeric John"
        
        
        coverImage.layer.shadowOpacity = 1
        coverImage.layer.shadowRadius = 6
        
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.coverImage.frame
//        rectShape.position = self.coverImage.center
//        rectShape.path = UIBezierPath(roundedRect: self.coverImage.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: coverImage.frame.size.width, height: coverImage.frame.size.height / 2)).cgPath
//        self.coverImage.layer.mask = rectShape
//        
//        let rectShapes = CAShapeLayer()
//        rectShapes.bounds = self.blurryView.frame
//        rectShapes.position = self.blurryView.center
//        rectShapes.path = UIBezierPath(roundedRect: self.blurryView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: blurryView.frame.size.width, height: blurryView.frame.size.height / 2)).cgPath
//        self.blurryView.layer.mask = rectShapes
        
        
        
        self.databaseRef.child("Users").child(UID).observe(.value, with: { (snaphot) in
            let shots = snaphot.value as! NSDictionary
            
            print(shots)
            
            self.lblName.text = shots["mFullName"] as? String
            self.coverImage.sd_setImage(with: URL(string: (shots["mPhotoUrl"] as? String)!))
            self.profileImage.sd_setImage(with: URL(string: (shots["mPhotoUrl"] as? String)!))
        })
        
    }
 
}
