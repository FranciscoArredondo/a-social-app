//
//  PostCell.swift
//  The Social Network
//
//  Created by Francisco on 7/17/17.
//
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.asCircle()
        postImage.roundCorners(cornerRadius: 3.0)
        
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        caption.text = post.caption
        likesLabel.text = "\(post.likes)"
        
        if image != nil {
            postImage.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("PF: Unable to download image from firbase storage.")
                } else {
                    print("PF: Image downloaded from firebase storage.")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
        
    }

}

extension UIImageView {
    
    func asCircle() {
        layer.cornerRadius = layer.bounds.height/2
        clipsToBounds = true
    }
    
    func roundCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
}
