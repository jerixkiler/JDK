//
//  SeeMemberTableViewController.swift
//  JDK
//
//  Created by Nexusbond on 02/06/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SeeMemberTableViewController: UITableViewController {
    
    var topic: Topic?
    
    var members = [ChatMembers]()
    
    var databaseRef: DatabaseReference!
    
    var uid:String = (Auth.auth().currentUser?.uid)!
    
    @IBOutlet var collectionViewMembers: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        print(topic!.topicID!)
        loadChatMembers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        loadChatMembers()
    }
    
    func loadChatMembers(){
        databaseRef.child("Topics").child((topic?.topicID!)!).child("members").observeSingleEvent(of: .value, with: {(snapshot) in
            self.members.removeAll()
            print("remove")
            
            let membersRef: DatabaseReference = self.databaseRef.child("Topics").child((self.topic?.topicID!)!).child("members")
            for snap in snapshot.children.allObjects as! [DataSnapshot]  {
                // print(snap.key)
                if snap.childrenCount == 3 {
                    print(snap.key)
                    let userUID: String = snap.key
                    
                    if userUID != "sample" {
                        membersRef.child(userUID).observeSingleEvent(of:.value, with: { (snapshots) in
                            // Get user value
                            let value = snapshots.value as? NSDictionary
                            let isActive = value?["isActive"] as? Bool
                            let isJoined = value?["isJoined"] as? Bool
                            var memberStatus: String?
                            if isActive == true {
                                memberStatus = "Active"
                            } else if isJoined == true {
                                memberStatus = "Joined"
                            } else {
                                memberStatus = "Pending"
                            }
                            self.databaseRef.child("Users").child(userUID).observeSingleEvent(of: .value, with: { (snapshot_user) in
                                let userValue = snapshot_user.value as? NSDictionary
                                let displayName = userValue?["mFullName"] as! String
                                let photoUrl = userValue?["mPhotoUrl"] as! String
                                print(displayName)
                                print(photoUrl)
                                print(memberStatus!)
                                let chatMember = ChatMembers(memberImageUrl: photoUrl, memberDisplayName: displayName, memberStatus: memberStatus!,memberUID: userUID)
                                self.members.append(chatMember)
                                DispatchQueue.main.async {
                                    self.collectionViewMembers.reloadData()
                                }
                            })
                        })
                    }
                }
                
            }
        })
    }
    
    func loadChatMembers1(){
        databaseRef.child("Topics").child((topic?.topicID!)!).child("members").observe(.value, with: {(snapshot) in
//            self.members.removeAll()
            print("remove")
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                print(snap.key)
            }
            
//            let membersRef: DatabaseReference = self.databaseRef.child("Topics").child((self.topic?.topicID!)!).child("members")
//            for snap in snapshot.children.allObjects as! [DataSnapshot]  {
//                // print(snap.key)
//                if snap.childrenCount == 3 {
//                    print(snap.key)
//                    let userUID: String = snap.key
//                    
//                    if userUID != "sample" {
//                        membersRef.child(userUID).observeSingleEvent(of:.value, with: { (snapshots) in
//                            // Get user value
//                            let value = snapshots.value as? NSDictionary
//                            let isActive = value?["isActive"] as? Bool
//                            let isJoined = value?["isJoined"] as? Bool
//                            var memberStatus: String?
//                            if isActive == true {
//                                memberStatus = "Active"
//                            } else if isJoined == true {
//                                memberStatus = "Joined"
//                            } else {
//                                memberStatus = "Pending"
//                            }
//                            self.databaseRef.child("Users").child(userUID).observeSingleEvent(of: .value, with: { (snapshot_user) in
//                                let userValue = snapshot_user.value as? NSDictionary
//                                let displayName = userValue?["mFullName"] as! String
//                                let photoUrl = userValue?["mPhotoUrl"] as! String
//                                print(displayName)
//                                print(photoUrl)
//                                print(memberStatus!)
//                                let chatMember = ChatMembers(memberImageUrl: photoUrl, memberDisplayName: displayName, memberStatus: memberStatus!,memberUID: userUID)
//                                self.members.append(chatMember)
//                                DispatchQueue.main.async {
//                                    self.collectionViewMembers.reloadData()
//                                }
//                            })
//                        })
//                    }
//                }
//                
//            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath)
        let cellIdentifier = "membersCell"
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SeeMemberViewCell else {
            fatalError("The dequeued cell is not an instance of membersCell.")
        }
        
        let member = members[indexPath.row]
        let memberStatus = member.memberStatus
        cell.displayNameText.text = member.memberDisplayName
        cell.userUIDInCell = member.memberUID
        cell.topicID = topic?.topicID
        cell.profileImageView.sd_setImage(with: URL(string: member.memberImageUrl!))
        if memberStatus == "Active" {
            cell.btnStatus.setTitle(memberStatus, for: .normal)
        } else if memberStatus == "Joined" {
            cell.btnStatus.setTitle("Not Active", for: .normal)
        } else {
            if topic?.ownerUserID == uid {
                cell.btnStatus.setTitle("Accept", for: .normal)
            } else {
                cell.btnStatus.setTitle("Pending", for: .normal)
            }
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
