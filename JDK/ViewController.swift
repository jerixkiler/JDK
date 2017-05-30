//
//  ViewController.swift
//  JDK
//
//  Created by Nexusbond on 30/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import GoogleSignIn
import QuartzCore
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForInput: UIView!

    
    let border = CALayer()
    let border1 = CALayer()
    let width = CGFloat(1.0)
    let width1 = CGFloat(1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogin()
        txtPassword.delegate = self
        txtUsername.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtUsername {
            txtPassword.becomeFirstResponder()
        }
        else if textField == self.txtPassword {
            textField.resignFirstResponder()
            self.btmConstraint.constant = 8
            self.btmConstraint.constant = 8
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.btmConstraint.constant = 8
        self.btmConstraint.constant = 8
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            self.btmConstraint.constant = 200
            self.btmConstraint.constant = 200
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        else{
            self.btmConstraint.constant = 50
            self.btmConstraint.constant = 50
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @IBAction func toogleSegment(_ sender: Any) {
        switch segmentControll.selectedSegmentIndex{
        case 0:
            btnLogin.setTitle("LOGIN", for: .normal)
        case 1:
            btnLogin.setTitle("CREATE USER", for: .normal)
        default:
            print("nothing is selected?")
        }
        
    }
    
    func setupLogin(){
        
        viewForInput.layer.cornerRadius = 10
        btnFacebook.layer.cornerRadius = 18
        btnGoogle.layer.cornerRadius = 18
        btnLogin.layer.cornerRadius = 18
        segmentControll.layer.cornerRadius = 18
        
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: txtUsername.frame.size.height - width, width:  txtUsername.frame.size.width, height: txtUsername.frame.size.height)
        border.borderWidth = width
        txtUsername.layer.addSublayer(border)
        txtUsername.layer.masksToBounds = true
        txtUsername.setPlaceholderText(placeholder: "EMAIL ADDRESS", color: UIColor.black)
        
        border1.borderColor = UIColor.black.cgColor
        border1.frame = CGRect(x: 0, y: txtPassword.frame.size.height - width, width: txtPassword.frame.size.width, height: txtPassword.frame.size.height)
        border1.borderWidth = width1
        txtPassword.layer.addSublayer(border1)
        txtPassword.layer.masksToBounds = true
        txtPassword.setPlaceholderText(placeholder: "PASSWORD", color: UIColor.black)
        
        
        segmentControll.layer.cornerRadius = 10
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toogleLoginOrCreate(_ sender: Any) {
        
        if segmentControll.selectedSegmentIndex == 0 {
            //check if user inputs email and password
            if txtUsername.text == "" || txtPassword.text == "" {
                let alert = UIAlertController(title: "Blank Textfield", message: "Please fill up Email and Password", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
            }
        }
        else{
            
        }
        
        
    }
    
    
    

    @IBAction func toogleGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

}

