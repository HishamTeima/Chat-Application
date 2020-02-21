//
//  RoomsViewController.swift
//  Chat Application
//
//  Created by Hisham Teima on 2/11/20.
//  Copyright © 2020 Hisham Teima. All rights reserved.
//

import UIKit
import Firebase
import  SVProgressHUD



class RoomsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
     
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var NewRoomTextField: UITextField!
    @IBOutlet weak var roomstable: UITableView!
    var rooms = [Room]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Access Global Variable Then Get IndexPath
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomstableviewcell")!
        //To Display in Table View
        cell.textLabel?.text = room.RoomName
        //To Change Color Of the cell
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "System-System", size: CGFloat(60))
        
        
        return cell
        
    }
    
    //This Fnction To Cratroom
    @IBAction func DIdPressCreatRoom(_ sender: UIButton) {
        
        
        guard let CratRoomName = self.NewRoomTextField.text , CratRoomName.isEmpty == false  else
        {
            return
        }
        //childByAutoId This To creat ID for rooms !
        let databaserefrence = Database.database().reference()
        let room = databaserefrence.child("Rooms").childByAutoId()
        let dataarray:[String:Any] = ["Roomname":CratRoomName]
        room.setValue(dataarray) { (erorr, refrence) in
            if (erorr == nil)
            {
                //When Creat Room With No Erorr Then Delete Text IN tEXTfILED 
                self.NewRoomTextField.text = ""
            }
            else
            {
                 self.displayerorr(erorrtext: "Invalid!")
            }
         
        }
        
    }
    
   // To Lisitining For New Rooms
   func observeRooms ()
   {
    let databaseref = Database.database().reference()
    databaseref.child("Rooms").observe(.childAdded) { (snapshot) in
        if let dataarray = snapshot.value as? [String:Any] {
           if  let roomname = dataarray["Roomname"] as? String
            {
                let room = Room(RoomName: roomname, RoomId:snapshot.key )
               self.rooms.append(room)
                self.roomstable.reloadData()
            }
        }
    }
    }
    
    
    //This Function To Push User After Select Room To Chat Room Story Board
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If User Select Any Room This Var Get Room Indexpath
        let SelectedRoom = self.rooms[indexPath.row]
        let ChatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomViewController
        //put index in chatroomview
        ChatRoomView.room = SelectedRoom
        
        self.navigationController?.pushViewController(ChatRoomView, animated: true)
    }
    
    // touch function To Escape From Keyboard
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        observeRooms()
        //remove  sepretors
        roomstable.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //FireBase Auth Check User If Loggin in Or not
       if ( Auth.auth().currentUser == nil)
       {
        // If User == nil its mean user Didn't Sign in Then Put Him in Login Screen
        
        self.PresentLoginScreen()
        }
        else
       {
        
        }
        
    }
    

    @IBAction func didPressLogout(_ sender: UIBarButtonItem) {
        
        // Logout Button To Return Into Login Screen !
        // Using Try forced Cause Sign out Throw
        //Tell Firebase Library That This User Has Logout !
         SVProgressHUD.show()
      try!  Auth.auth().signOut()
         SVProgressHUD.dismiss()
        self.PresentLoginScreen()
        
    }
    
    func PresentLoginScreen ()  {
        let formscreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        
        self.present(formscreen, animated: true, completion: nil)
        
    }
    func displayerorr(erorrtext:String )
    {
        let alert = UIAlertController.init(title: "Erorr", message: erorrtext, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        //To Display Ok Button In ERORR Messege
        let DismissButton = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(DismissButton)
    }
    

}

extension RoomsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == NewRoomTextField{
            return false
        }
        else{
            return true
        }
    }
}

