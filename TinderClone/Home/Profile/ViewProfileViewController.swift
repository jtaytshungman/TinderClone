//
//  ViewProfileViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userDescTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfoHandler()
        descBoxDisplay.descTextViewAppear(textView: userDescTextView)
        ProfilePicDisplay.profileBounds(image: profilePictureImageView)
        
        profileNavBar.backgroundColor = UIColor.clear
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        dismissViewHandler()
    }
    
    func dismissViewHandler () {
        dismiss(animated: true, completion: nil)
    }
    
    func loadUserInfoHandler () {
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
                                self.profilePictureImageView.image = UIImage(data: data)
                            }
                        }
                    }
                    task.resume()
                }
                
                if
                    let gender = dictionary["gender"] as? String,
                    let age = dictionary["age"] as? String,
                    let name = dictionary["name"] as? String,
                    let desc = dictionary["userDesc"] as? String {
                    
                    self.genderLabel.text = gender
                    self.ageLabel.text = "\(age) years old"
                    self.userNameLabel.text = name
                    self.userDescTextView.text = desc
                    
                }
            }
        }, withCancel: nil)
    }
    
    
}


