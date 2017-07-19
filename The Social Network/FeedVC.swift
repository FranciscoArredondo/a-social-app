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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var postImageView: UIButton!
    @IBOutlet weak var captionField: SignInUITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController();
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageView.image = image
            imageSelected = true
        } else {
            print("PF: A vaild image was not selected")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        
        guard let caption = captionField.text, caption != "" else {
            print("PF: Caption must be entered.")
            return
        }
        
        guard let img = addImageView.image, imageSelected else {
            print("PF: An image must be selected.")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            DataService.ds.REF_POSTS_IMAGES.child(imageUid).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("PF: unable to upload image to firebase storage")
                } else {
                    print("PF: Sucessfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                    
                }
            }
        }
        
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        let keychainWrapper = KeychainWrapper.standard.remove(key: KEY_UID)
        print("PF: Id removed from keychain \(keychainWrapper)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, Any> = ["caption": captionField.text!,
                                             "imageUrl": imageUrl,
                                             "likes" : 0]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImageView.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
}
