//
//  topicController.swift
//  JDK
//
//  Created by Nexusbond on 31/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class topicController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var databaseRef: DatabaseReference!
    var topicRef: DatabaseReference = Database.database().reference().child("Topics")
    
    var topics = [Topic]()
    
    var uid: String = (Auth.auth().currentUser?.uid)!
    
    var userUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        databaseRef = Database.database().reference()
        loadHomeFeed()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        if userUID != topic.ownerUserID {
            promptToWaitForOwnerResponse(topicID: topic.topicID!,topicSender: topic)
            let cell = collectionView.cellForItem(at: indexPath) as! customCell
            if cell.joinButton.titleLabel?.text == "Join" {
                cell.joinButton.setTitle("Pending", for: .normal)
            }
        } else {
            print("Owner clicked!")
            performSegue(withIdentifier: "goToChat", sender: topic)
        }
    }
    
    func promptToWaitForOwnerResponse(topicID: String , topicSender: Topic){
        
        databaseRef.child("Topics").child(topicID).observeSingleEvent(of: .value, with: {(snapshot) in
            //if snapshot.hasChild("members") {
            self.databaseRef.child("Topics").child(topicID).child("members").observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as! NSDictionary
                
                if snapshot.hasChild(self.uid) , let memberValue = value[self.uid] as? NSDictionary {
                    if memberValue["isJoined"] as! Bool == false {
                        let alertController = UIAlertController(title: "Waiting", message: "Response is being sent", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //                        self.databaseRef.child("Topics").child(topicID).child("members").updateChildValues([(Auth.auth().currentUser?.uid)!:false])
                        alertController.addAction(okButton)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        //                            cell.joinButton.setTitle("Connect", for: .normal)
                        print("Accepted")
                        self.performSegue(withIdentifier: "goToChat", sender: topicSender)
                    }
                } else {
                    let alertController = UIAlertController(title: "Response is sent", message: "Wait for response", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.databaseRef.child("Topics").child(topicID).child("members").updateChildValues([(Auth.auth().currentUser?.uid)!:["isJoined": false , "isActive":false,"isTyping":false]])
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                //                    if value[self.uid] as! Bool == false {
                //                        let alertController = UIAlertController(title: "Waiting", message: "Response is being sent", preferredStyle: .alert)
                //                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                ////                        self.databaseRef.child("Topics").child(topicID).child("members").updateChildValues([(Auth.auth().currentUser?.uid)!:false])
                //                        alertController.addAction(okButton)
                //                        self.present(alertController, animated: true, completion: nil)
                //                    } else {
                //                        print("Accepted")
                //                        self.performSegue(withIdentifier: "goToChat", sender: topicSender)
                //                    }
            })
            // } else {
            
            // }
            
        })
        
        
        
        
        
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "topicCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? customCell else {
            fatalError("The dequeued cell is not an instance of HomeFeedCell.")
        }
        cell.backgroundImageView.layer.cornerRadius = cell.backgroundImageView.frame.size.width / 2
        let topic = topics[indexPath.row]
        DispatchQueue.main.async {
            cell.topicDescriptionLabel.text = topic.topicDescription
            cell.backgroundImageView.sd_setImage(with: URL(string: topic.photoBackgroundUrl!))
            if self.userUID == topic.ownerUserID {
                cell.joinButton.isHidden = true
            } else {
                self.databaseRef.child("Topics").child(topic.topicID!).child("members").observeSingleEvent(of: .value, with: {(snapshot) in
                    let value = snapshot.value as! NSDictionary
                    if snapshot.hasChild(self.uid) , let memberValue = value[self.uid] as? NSDictionary {
                        if memberValue["isJoined"] as! Bool == false {
                            cell.joinButton.setTitle("Pending", for: .normal)
                        } else {
                            cell.joinButton.setTitle("Connect", for: .normal)
                        }
                    }
                })
                cell.joinButton.isHidden = false
            }
        }
        return cell
    }
    func loadHomeFeed(){
        topics.removeAll()
        let topicRef: DatabaseReference = databaseRef.child("Topics")
        databaseRef.child("Topics").observeSingleEvent(of: .value, with: { (snapshot) in
            //let snapshot = snapshot.value as? NSDictionary
            for snap in snapshot.children.allObjects as! [DataSnapshot]  {
                topicRef.child(snap.key).observe(.value, with: { (snapshots) in
                    // Get user value
                    let value = snapshots.value as? NSDictionary
                    let userID = value?["owner_userID"] as? String
                    let photoBackgroundUrl = value?["photo_background_url"] as? String
                    let timeCreated = value?["time_created"] as? Double
                    let topicDescription = value?["topic_description"] as? String
                    let newTopic = Topic(ownerUserID: userID!, photoBackgroundUrl: photoBackgroundUrl!, timeCreated: timeCreated!, topicDescription: topicDescription! , topicID: snap.key)
                    print("\(userID!)  \(photoBackgroundUrl!)  \(timeCreated!)  \(topicDescription!)")
                    self.topics.append(newTopic)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 129/255, green: 215/255, blue: 251/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPostAction(_ sender: Any) {
        performSegue(withIdentifier: "goToAddPost", sender: nil)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToAddPost" {
            print("Go To Add Post")
            let atvc = segue.destination as? AddTopicViewController
            atvc?.userUID = userUID
        } else if segue.identifier == "goToChat" {
            print("Go To Chat")
            if let topic = sender as? Topic {
                let nav = segue.destination as! UINavigationController
                let chatVc = nav.viewControllers.first as! ChatViewController
                chatVc.senderDisplayName = "Sample"
                chatVc.topic = topic
                chatVc.topicRef = topicRef.child(topic.topicID!)
            }
        }
        
        
        
    }
    
    
}
