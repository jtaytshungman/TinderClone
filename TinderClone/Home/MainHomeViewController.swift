//
//  MainHomeViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
import Firebase
import DMSwipeCards

class MainHomeViewController: UIViewController {
    
    var users : [User] = []
    var userNames : [String] = []
    var userAge : [String] = []
    var userImageURL : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        self.title = "Tinder"
        
        swipingView()
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
    
    func dislikeButtonHandler() {
        print("PASS")
    }
    
    func likeButtonHandler() {
        print("LIKE")
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
    
    func swipingView () {
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            // return a UIView here
            
            let container = UIView(frame: CGRect(x: 30, y: 20, width: frame.width - 60, height: frame.height - 40))
            let label = UILabel(frame: container.bounds)
            label.text = element
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 48, weight: UIFontWeightThin)
            label.clipsToBounds = true
            label.layer.cornerRadius = 16
            container.addSubview(label)
            
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            return container
            
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            // return a UIView here
            
            let label = UILabel()
            return label
            
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 200)
        
        let swipeView = DMSwipeCardsView<String>(frame: frame, viewGenerator: viewGenerator, overlayGenerator: overlayGenerator)
        
        swipeView.delegate = self
    
    }
}


extension MainHomeViewController : DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        print("Swiped")
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped")
    }
    
    func cardTapped(_ object: Any) {
        print("Swiped")
    }
    
    func reachedEndOfStack() {
        print("Swiped")
    }

}


