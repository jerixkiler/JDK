//
//  ViewController.swift
//  JDK
//
//  Created by Nexusbond on 30/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import GoogleSignIn
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toogleGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

}

