//
//  AddTopicViewController.swift
//  JDK
//
//  Created by Nexusbond on 30/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import os.log
import FirebaseStorage

class AddTopicViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    var imageDataTemporary: Data?
    var imageDataUrl: String?
    var databaseRef: DatabaseReference!
    var userUID: String?
    var topicDictionary: [String: Any] = [:]
    var topicId: String?
    
    var topic: Topic?
    
    var time_created: Double?
    
    @IBOutlet weak var backgroundImageTopic: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        navigationItem.title = "Add Topic"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTopicAction(_ sender: Any) {
        uploadImagePartTwo(data: imageDataTemporary!)
        topicId = databaseRef.childByAutoId().key
        time_created = NSDate().timeIntervalSince1970
        topicDictionary = ["topic_description" : descriptionTextField.text!,"owner_userID": userUID! , "time_created": time_created , "members":["sample":false]]
        databaseRef.child("Topics").child(topicId!).setValue(topicDictionary)
        print("Topic Added!")
        //      dismiss(animated: true, completion: nil)
    }
    
    //    func updateTopicDictionary(topicDictionary: inout [String:Any]){
    //        topicDictionary["photo_background_url"] = imageDataUrl
    //
    //    }
    
    func updateTopicRoot(){
        databaseRef.child("Topics").child(topicId!).updateChildValues(["photo_background_url": imageDataUrl!])
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage , let imageData = UIImageJPEGRepresentation(selectedImage, 0.2) else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        backgroundImageTopic.image = selectedImage
        imageDataTemporary = imageData
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerController(){
        print("Clicked the image view")
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        presentImagePickerController()
    }
    
    func uploadImagePartTwo(data: Data){
        let storageRef = Storage.storage().reference(withPath: "\(userUID!)/\(databaseRef.childByAutoId().key)")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "images/jpeg"
        let uploadTask = storageRef.putData(data, metadata: uploadMetaData, completion: { (metadata,error) in
            if(error != nil){
                print("I received an error! \(error?.localizedDescription ?? "null")")
            } else {
                let downloadUrl = metadata!.downloadURL()
                self.imageDataUrl = downloadUrl?.absoluteString
                print("Upload complete! Heres some metadata!! \(String(describing: metadata))")
                print("Here's your download url \(downloadUrl!)")
                self.updateTopicRoot()
                self.navigationController?.popViewController(animated: true)
                //self.performSegue(withIdentifier: "unwindSegueAddTopic", sender: nil)
                //self.updateTopicDictionary(topicDictionary: &self.topicDictionary)
                //                let userImagesDictionary = ["user_image_url" : "\(downloadUrl!)","about_me_display": aboutDisplay , "gender": userGender , "phone" : phone , "username" : username , "location": location]
                //                self.updateProfile(userDictionary: userImagesDictionary as! [String : String], uid: uid)
            }
        })
    }
    
    func updateTopic(topic: Topic){
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        guard let button = sender as? UIButton, button === postButton else {
//            os_log("The post button was not pressed, cancelling", log: OSLog.default, type: .debug)
//            return
//        }
//        let desc = descriptionTextField.text
//        let photoUrl = imageDataUrl!
//        topic = Topic(ownerUserID: userUID!, photoBackgroundUrl: photoUrl, timeCreated: time_created!, topicDescription: desc!)
    }
}
