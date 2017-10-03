//
//  SwipingViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 03/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SwipingViewController: UIViewController {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
}

extension SwipingViewController {
    
    func loadOtherUsersHandler() {
        
        let randomNumber = Int(arc4random_uniform(UInt32(users.count)))
        let currentUser = users[randomNumber]
        
        let age = currentUser.age
        let name = currentUser.name
        
        if let profileImageURL = currentUser.userImageURL {
            profilePictureImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
            profilePictureImageView.contentMode = .scaleAspectFit
        }
        
        self.ageLabel.text = age;" years old"
        self.userNameLabel.text = name
        
    }
    
    func fetchUser () {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.loadOtherUsersHandler()
                }
            }
            
        }, withCancel: nil)
        
    }
 
}
