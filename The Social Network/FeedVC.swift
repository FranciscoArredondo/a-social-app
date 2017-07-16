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

class FeedVC: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainWrapper = KeychainWrapper.standard.remove(key: KEY_UID)
        print("PF: Id removed from keychain \(keychainWrapper)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
