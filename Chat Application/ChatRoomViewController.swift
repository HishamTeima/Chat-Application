//
//  ChatRoomViewController.swift
//  Chat Application
//
//  Created by Hisham Teima on 2/12/20.
//  Copyright © 2020 Hisham Teima. All rights reserved.
//

import UIKit
import Firebase


class ChatRoomViewController: UIViewController,UITableViewDataSource , UITableViewDelegate
, UITextFieldDelegate {
    
   
    @IBOutlet weak var ChatTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessges.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messege = self.ChatMessges[indexPath.row]
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatRoomCell") as! ChatCell
        cell.setMessgeData(messege: messege)
        cell.ChatTextView.text = messege.MessageText
        
        if (messege.UserId == Auth.auth().currentUser!.uid)
        {
            cell.setbubbleType(type: .outgoing)
        }
        else
        {
            cell.setbubbleType(type: .incoming)
        }
        
       
        
        return cell 
    }
    
    
    
    @IBOutlet weak var ChatTextFileds: UITextField!
    
    var room:Room?
    
    var ChatMessges = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       observeMesseges()
       
        //Ro Remove Lines In Table View
        ChatTableView.separatorStyle = .none
        
        // To Cancel Select
        ChatTableView.allowsSelection = false
        
        // To Set TITLE iN Navbar
        title = room?.RoomName
       
        // Do any additional setup after loading the view.
        
    }
    
   
    
    func observeMesseges ()
    {
        guard let roomId = self.room?.RoomId
        else
        {
            return
        }
        let databaseref = Database.database().reference()
        databaseref.child("Rooms").child(roomId).child("messages").observe(.childAdded) { (snapshot) in
            if let DataArray = snapshot.value as? [String:Any]
            {
                guard let SenderName =  DataArray["SenderName"] as? String , let MessageText = DataArray["Text"] as? String , let userid = DataArray["SenderId"] as? String    else
                {
                    return
                }
                let messege = Message.init(MassageKey: snapshot.key, SenderName: SenderName, MessageText: MessageText, UserId: userid)
                
                 self.ChatMessges.append(messege)
               
                self.ChatTableView.reloadData()
                
            }
        }
        
    }
    
    func SendMessage (Text:String)
    {
        
       guard let  userid = Auth.auth().currentUser?.uid else {
        return
        }
        // To Access Database
        let DataBaserefrenece = Database.database().reference()
        
        let user = DataBaserefrenece.child("users").child(userid)
        
        //Get Username
        user.child("Username").observe(.value) { (snapshot) in
            if let UserName = snapshot.value as? String{
                if let roomid = self.room?.RoomId , let userid = Auth.auth().currentUser?.uid
                {
                    let dataarray:[String:Any] = ["SenderName":UserName , "Text":Text , "SenderId" : userid]
                    let room =  DataBaserefrenece.child("Rooms").child(roomid)
                    room.child("messages").childByAutoId().setValue(dataarray, withCompletionBlock: { (erorr, ref) in
                        if (erorr == nil )
                        {
                            
                            self.ChatTextFileds.text = ""
                            
                            print("Room Added Successful To Database")
                        }
                    }
                    )
                    
                }
            }
            
        }
    }
    
    
    
    
    @IBAction func DidPressSendBtn(_ sender: UIButton) {
        // If User Send Emptty Messge 
        guard let  ChatText = self.ChatTextFileds.text, ChatText.isEmpty == false
            
        else
       {
        return
        }
        SendMessage(Text: ChatText)
   
    
}
}
