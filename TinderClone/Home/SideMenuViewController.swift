//
//  SideMenuViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SideMenuViewController: UIViewController {

    @IBOutlet weak var menuProfileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        ProfilePicDisplay.profileBounds(image: menuProfileImage)
        loadProfileImageHandler()
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
    
    func loadProfileImageHandler() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(currentUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                if let profilePicURL = dictionary["userImageURL"] as? String {
                    guard let url = URL(string : profilePicURL) else {
                        return
                    }
                    
                    let session = URLSession.shared
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print ("Error : \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            //self.pokemonImageView.image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.menuProfileImage.image = UIImage(data: data)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }, withCancel: nil)
    }
}
