//
//  MainHomeViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import SideMenu

class MainHomeViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        sideMenuHandler() // handling sidemenu api
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        dislikeButtonHandler()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButtonHandler()
    }
    
}

extension MainHomeViewController {
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
    
    func dislikeButtonHandler() {
        
    }
    
    func likeButtonHandler() {
        
    }
}
