//
//  SignInViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func SignInButtonTapped(_ sender: Any) {
        signInHandler()
        
    }
    
    func signInHandler(){
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if self.emailTextField.text == "" {
                PromptHandler.showPrompt(title: "Empty Email Field", message: "Please input valid Email", in: self)
                return
            } else if self.passwordTextField.text == "" {
                PromptHandler.showPrompt(title: "Empty Password Field", message: "Please input valid password", in: self)
                return
            }
            
            if let validError = error {
                print(validError.localizedDescription)
                //self.createErrorAlert("Error", validError.localizedDescription)
                PromptHandler.showPrompt(title: "Error", message: "\(validError.localizedDescription)", in: self)
            }
            
            if let validUser = user {
                print(validUser)
                self.correctSignInHandler()
            }
            
        }
        
    }
    
    func correctSignInHandler(){
        
        let home = UIStoryboard(name: "Home", bundle: nil)
        
        guard let vc = home.instantiateViewController(withIdentifier: "MainHomeNavigationController") as? UINavigationController else {
            return print("Error--------------------------Correct SignIn Handler")
        }
        present(vc, animated: true, completion: nil)
    }

}
