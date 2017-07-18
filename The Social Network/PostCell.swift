//
//  PostCell.swift
//  The Social Network
//
//  Created by Francisco on 7/17/17.
//
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        caption.text = post.caption
        likesLabel.text = "\(post.likes)"
        
        // temporary for now...
        let url = URL(string: post.imageUrl)!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    self.postImage.image = UIImage(data: data)
                }
            } catch {
                // handel the error
            }
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
