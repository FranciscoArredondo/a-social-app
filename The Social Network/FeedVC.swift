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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("PF: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
        
        postImageView.asCircle()
        addImageView.asCircle()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print("PF: \(post.caption)")
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    

    @IBAction func signOutButtonPressed(_ sender: Any) {
        let keychainWrapper = KeychainWrapper.standard.remove(key: KEY_UID)
        print("PF: Id removed from keychain \(keychainWrapper)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
