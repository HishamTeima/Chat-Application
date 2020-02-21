//
//  ViewController.swift
//  Chat Application
//
//  Created by Hisham Teima on 2/10/20.
//  Copyright © 2020 Hisham Teima. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView
import SVProgressHUD


class ViewController: UIViewController ,UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout
    , UITextFieldDelegate {
   
    
   
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named:"logo.png")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(red:0.29, green:0.58, blue:0.86, alpha:1.0))
        
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
 
        //Duarion
         revealingSplashView.duration = 8.0
        //Shape
       revealingSplashView.animationType = SplashAnimationType.woobleAndZoomOut
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        // Do any additional setup after loading the view.
        self.collectionview.delegate = self
    self.collectionview.dataSource = self
        let refrence = Database.database().reference()
        
        //this step for save User Id In Database in FireBase
        let Rooms = refrence.child("Rooms")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionview.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath)
        as! formCell
        
        //Sign IN Page
        
        if (indexPath.row == 0 )
        {
            cell.UserNameContainer.isHidden = true //Sign IN
            cell.ActionButton.setTitle("Sign in", for: .normal)
            cell.SlideButton.setTitle("Sign Up", for: .normal)
            
            cell.SlideButton.addTarget(self, action: #selector(SlideToSignInCell(_:)), for: .touchUpInside)
            cell.ActionButton.addTarget(self, action: #selector(DidPressLogin(_:)), for: .touchUpInside)
            
        }
            //SignUP Page
            
        else if (indexPath.row == 1 )
        {
            cell.UserNameContainer.isHidden = false // Sign up
            cell.ActionButton.setTitle("Sign Up", for: .normal)
            cell.SlideButton.setTitle("Sign In", for: .normal)
             cell.SlideButton.addTarget(self, action: #selector(SlideToSignUpCell(_:)), for: .touchUpInside)
            cell.ActionButton.addTarget(self, action: #selector(didPressSignUp(_:)), for:.touchUpInside)
            
        }
        return cell
    }
    

    

    
    //  Conform Protcol UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionview.frame.size
    }
    
    
    // If User SignUp Then This Function Register new account On Firebase
    @objc func didPressSignUp(_ sender: UIButton){
        let indexpath = IndexPath(row: 1, section: 0)
        let cell = self.collectionview.cellForItem(at: indexpath ) as! formCell
        guard let EmailAddress = cell.EmailAddressTextField.text , let password = cell.PasswordTextField.text
        else
        {
            return
        }
        if (EmailAddress.isEmpty == true || password.isEmpty == true )
        {
            SVProgressHUD.dismiss()
            
            self.displayerorr(erorrtext: "Please Fill Empty Fileds")
        }
        else
        {
            SVProgressHUD.show()
            
        //This for Creat New User On FireBase
        Auth.auth().createUser(withEmail: EmailAddress, password: password) { (result, erorr) in
            if (erorr == nil)
            {
                
            print(result)
                
                SVProgressHUD.dismiss()
                
               guard let userid = result?.user.uid , let Username = cell.UsernameTextField.text
                else
               {
                SVProgressHUD.dismiss()
                
                return
                }
                
                    
                    //If Signup Success Then Return User To Chat Rooms
                    self.dismiss(animated: true, completion: nil)
                
                //Refrence Var for Acsess DataBase
               let refrence = Database.database().reference()
                
                //this step for save User Id In Database in FireBase
                let user = refrence.child("users").child(userid)
                let dataArray:[String:Any] = ["Username": Username]
                user.setValue(dataArray)
            }
           
        }
        }
    }
    
    //This Functions To Slide Between Signin Page & SignUp Page
    @objc func SlideToSignInCell (_ Sender:UIButton )
    {
        
        let indexpath = IndexPath(row: 1, section: 0)
        self.collectionview.scrollToItem(at: indexpath, at: .centeredVertically, animated: true)
    }
    
    @objc func SlideToSignUpCell (_ Sender:UIButton )
    {
        
        let indexpath = IndexPath(row: 0, section: 0)
        self.collectionview.scrollToItem(at: indexpath, at: .centeredVertically, animated: true)
    }
    
    //for Display Erorr Alert !!
    func displayerorr(erorrtext:String )
    {
        let alert = UIAlertController.init(title: "Erorr", message: erorrtext, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        //To Display Ok Button In ERORR Messege
        let DismissButton = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(DismissButton)
    }
    
    @objc func DidPressLogin (_ Sender: UIButton)
    {
        
        let indexpath = IndexPath(row: 0, section: 0)
        let cell = self.collectionview.cellForItem(at: indexpath) as! formCell
      guard let EmailAddress = cell.EmailAddressTextField.text , let password = cell.PasswordTextField.text
        
        else
        {
            return
        }
         SVProgressHUD.show()
        
        // If user Didn't Fill Fileds
        if (EmailAddress.isEmpty == true || password.isEmpty == true)
        {
            //if true
           
            self.displayerorr(erorrtext: "Please Fill Empty Fileds")
            SVProgressHUD.dismiss()
        }
        else
        {
            
            
        Auth.auth().signIn(withEmail: EmailAddress, password: password) { (result, erorr) in
            if (erorr == nil)
            {
                //If Login Success Then Return User To Chat Rooms
                self.dismiss(animated: true, completion: nil)
                print(result)
                SVProgressHUD.dismiss()
                
            }
           else
            {
               self.displayerorr(erorrtext: "Incorrect Username or Password ")
                SVProgressHUD.dismiss()
            }
        }
        }
     
    }
}

