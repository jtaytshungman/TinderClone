//
//  SelectedUserDetailsViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 03/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

class SelectedUserDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchUser () {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
            }
            
        }, withCancel: nil)
        
    }
    
    
    
}
