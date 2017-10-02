//
//  SignUpViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUpHandler()
    }
    
    func signUpHandler() {
        
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if password != confirmPassword {
            PromptHandler.showPrompt(title: "Password Error", message:  "Passwords do not match", in: self)
            return
        } else if email == "" || password == ""{
            PromptHandler.showPrompt(title: "Missing input field", message: "Input field must be filled", in: self)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (fireUser, error) in
            
            // what to do when error
            if let error = error {
                PromptHandler.showPrompt(title: "Warning", message: "\(error.localizedDescription)", in: self)
            }
            
            
            
            // Successful Users
            guard let uid = fireUser?.uid else { return }
            let ref = Database.database().reference(fromURL: "https://tinderclone-5541e.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name" : name, "email" : email]
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err?.localizedDescription as Any)
                }
                self.toSignInVC()
                return
            })
            
        }
        
    }
    
    func toSignInVC(){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
}
