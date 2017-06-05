//
//  ChatViewController.swift
//  JDK
//
//  Created by Nexusbond on 31/05/2017.
//  Copyright © 2017 Nexusbond. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SDWebImage
class ChatViewController:  JSQMessagesViewController{
    
    // MARK: Properties
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: DatabaseReference = self.topicRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    var uid: String = (Auth.auth().currentUser?.uid)!
    
    var isStarting: Bool = true
    
    var topicRef: DatabaseReference!
    var databaseRef: DatabaseReference!
    var topic: Topic? {
        didSet {
            title = topic?.topicDescription
        }
    }
    
    private lazy var usersTypingQuery: DatabaseQuery =
        self.databaseRef!.child("Topics").child(self.topic!.topicID!).child("typing_indicator").queryOrderedByValue().queryEqual(toValue: true)
    
    private lazy var userIsTypingRef: DatabaseReference = self.databaseRef!.child("Topics").child(self.topic!.topicID!).child(self.senderId).child("isTyping")
    // 1
    //var userIsTyping: DatabaseReference = Database.database().reference().child("Topics").child(topic.topicID).child("members").child(uid)
    
    
    
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = databaseRef!.child("Topics").child((topic?.topicID)!).child("typing_indicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.setValue(isTyping)
        
        // 1
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            // 2 You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            // 3 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeTyping()
    }
    // Helper methods to use outgoing or incoming bubble
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // Get the message
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    // Count the messages to display
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    // For avatar images function
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        //return nil
        
        
        
        let placeHolderImage = UIImage(named:"no_image")
//       let avatarImage = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "DL", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let avatarImage = JSQMessagesAvatarImage(avatarImage: nil, highlightedImage: nil, placeholderImage: placeHolderImage)

        
        let message = messages[indexPath.item]
        
        if avatarImage?.avatarImage == nil {
            avatarImage?.avatarImage = SDImageCache.shared().imageFromDiskCache(forKey: message.senderId)
        }
        
        //
        
        if let messageID = message.senderId {
            databaseRef.child("Users").child(messageID).observe(.value, with: { (snapshot) in
                if let profileURL = (snapshot.value as AnyObject!)!["mPhotoUrl"] as! String! {
                    let profileNSURL: NSURL = NSURL(string: profileURL)!
                    let manager: SDWebImageManager = SDWebImageManager.shared()
                    manager.imageDownloader?.downloadImage(with: profileNSURL as URL, options: [], progress: nil, completed: {(image , error , cached , url) in
                        if image != nil {
                            manager.imageCache?.store(image, forKey: message.senderId)
                            
                            DispatchQueue.main.async{
                                avatarImage!.avatarImage = image
                                avatarImage!.avatarHighlightedImage = image
                                
                            }
                        }
                        //avatarImage?.avatarImage = image
                    })
                }
            })
        }
        
        return avatarImage
        
    }
    
    // Setting the bubble if user or not
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
        
        isTyping = false
    }
    
    
    
    private func observeMessages() {
        
        messageRef = topicRef!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
        
        if self.isStarting != true {
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        }
        self.isStarting = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = Auth.auth().currentUser?.uid
        self.senderDisplayName = "Sample"
        databaseRef = Database.database().reference()
        print(senderId)
        observeMessages()
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func seeMembers(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMembers", sender: topic)
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        if topic?.ownerUserID != uid {
            databaseRef.child("Topics").child((topic?.topicID)!).child("members").child(uid).updateChildValues(["isActive":false])
        }
        dismiss(animated: true, completion: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToMembers" {
            let smtvc = segue.destination as! SeeMemberTableViewController
            smtvc.topic = topic
        }
    }
    

}
