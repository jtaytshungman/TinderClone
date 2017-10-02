//
//  SideMenuViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"

    }
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as? ViewProfileViewController else { return }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func matchButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MatchedListViewController") as? MatchedListViewController else { return }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.logoutPrompt()
    }
    
    //MARK: Logout Functions
    func logoutPrompt() {
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let logout = UIAlertAction(title: "Log Out", style: .default) { (action) in
            self.logoutHandler()
        }
        
        logoutAlert.addAction(cancel)
        logoutAlert.addAction(logout)
        present(logoutAlert, animated: true, completion: nil)
    }
    
    func logoutHandler(){
        let auth = UIStoryboard(name: "Auth", bundle: nil)
        guard let vc = auth.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
        present(vc, animated: true, completion: nil)
    }
}

