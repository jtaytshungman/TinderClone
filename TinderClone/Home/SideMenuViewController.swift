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
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func matchButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let auth = UIStoryboard(name: "Auth", bundle: nil)
        guard let vc = auth.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
        present(vc, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}

