//
//  FeedVC.swift
//  The Social Network
//
//  Created by Francisco on 7/16/17.
//
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var postImageView: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        postImageView.asCircle()
        addImageView.asCircle()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    

    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainWrapper = KeychainWrapper.standard.remove(key: KEY_UID)
        print("PF: Id removed from keychain \(keychainWrapper)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
