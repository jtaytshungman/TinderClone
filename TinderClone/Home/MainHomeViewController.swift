//
//  MainHomeViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
import Firebase

class MainHomeViewController: UIViewController {

    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeCurrentUser()
        sideMenuHandler() // handling sidemenu api
        fetchUsers()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        dislikeButtonHandler()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButtonHandler()
    }
    
}

extension MainHomeViewController {
    
    func observeCurrentUser() {
        // retrieving user's name to know that they are signed in
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var userName = dictionary["name"] as? String
                self.title = userName
            }
        }, withCancel: nil)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User ()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                print("Fetch Successful")
            }
            
        }, withCancel: nil)
    }
    
    func dislikeButtonHandler() {
        
    }
    
    func likeButtonHandler() {
        
    }
    
    func sideMenuHandler () {
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuViewController())
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: SideMenuViewController())
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        
        guard let navigation = UIViewController().navigationController?.navigationBar else { return }
        SideMenuManager.menuAddPanGestureToPresent(toView: navigation)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: navigation)
        
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }

    
}
