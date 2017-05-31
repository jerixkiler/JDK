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
    
    var topics = [Topic]()
    
    var userUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        databaseRef = Database.database().reference()
        loadHomeFeed()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "topicCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? customCell else {
            fatalError("The dequeued cell is not an instance of HomeFeedCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let topic = topics[indexPath.row]
        DispatchQueue.main.async {
            cell.topicDescriptionLabel.text = topic.topicDescription
            cell.backgroundImageView.sd_setImage(with: URL(string: topic.photoBackgroundUrl!))
            if self.userUID == topic.ownerUserID {
                cell.joinButton.isHidden = true
            } else {
                cell.joinButton.isHidden = false
            }
        }
        // cell.ratingControl.rating = meal.rating!
        return cell
    }
    
    func loadHomeFeed(){
        
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
                    let newTopic = Topic(ownerUserID: userID!, photoBackgroundUrl: photoBackgroundUrl!, timeCreated: timeCreated!, topicDescription: topicDescription!)
                    print("\(userID!)  \(photoBackgroundUrl!)  \(timeCreated!)  \(topicDescription!)")
                    self.topics.append(newTopic)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        })
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
            
        }
    }
    

}
