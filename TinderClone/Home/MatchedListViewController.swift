//
//  MatchedListViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

class MatchedListViewController: UIViewController {

    var matchedUsers : [MatchedUsers] = []
    
    @IBOutlet weak var matchedTableView: UITableView! {
        didSet {
            matchedTableView.dataSource = self
            matchedTableView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MatchedListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchedTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
