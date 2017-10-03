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
import Koloda


class MainHomeViewController: UIViewController {
    
    var users : [User] = []
    
    @IBOutlet weak var kolodaProfileImage: UIImageView!
    @IBOutlet weak var kolodaView: KolodaView! {
        didSet {
            kolodaView.dataSource = self
            kolodaView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        self.title = "Tinder"
        
        sideMenuHandler() // handling sidemenu api
        fetchUsers()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        dislikeButtonHandler()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButtonHandler()
    }
    
}

extension MainHomeViewController {
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                print("Fetch Successful")
                
                
            }
            
        }, withCancel: nil)
    }
    
    func dislikeButtonHandler() {
        print("PASS")
    }
    
    func likeButtonHandler() {
        print("LIKE")
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
}

extension MainHomeViewController : KolodaViewDelegate {
    
}

extension MainHomeViewController : KolodaViewDataSource {
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if let userProfileImageUrlStr = users[index].userImageURL {
            kolodaProfileImage.loadImageUsingCacheWithURLString(urlString: userProfileImageUrlStr)
        }
        return kolodaView
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
}

//extension MainHomeViewController : KolodaViewDelegate {
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        kolodaView.reloadData()
//    }
//}
//
//extension MainHomeViewController : KolodaViewDataSource {
//
//    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        let profileImage = UIImageView()
//        if let viewingUserProfileURL = users[index].userImageURL {
//            profileImage.loadImageUsingCacheWithURLString(urlString: viewingUserProfileURL)
//        }
//
//        return profileImage
//    }
//
//    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
//        return users.count
//    }
//
//    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
//        return .fast
//    }
//}




