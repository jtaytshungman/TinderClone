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
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            // what to do when error
            if let error = error {
                PromptHandler.showPrompt(title: "Error", message: "\(error.localizedDescription)", in: self)
            }
            
            // Checking users
            if let user = user {
                let ref = Database.database().reference()
                
                let post : [String : Any] = ["email" : email ]
                ref.child("users").child(user.uid).setValue(post)
                
                // To sign in page
                self.navigationController?.popViewController(animated: true)
                let authStoryBoard = UIStoryboard(name: "Auth", bundle: nil)
                guard let vc = authStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
                self.dismiss(animated: true, completion: nil)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        
        
    }
    
    
    
    
}
