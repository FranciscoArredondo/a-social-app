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
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.asCircle()
        postImage.roundCorners(cornerRadius: 3.0)
        
        // Initialization code
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
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
