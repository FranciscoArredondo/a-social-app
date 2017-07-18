//
//  Post.swift
//  The Social Network
//
//  Created by Francisco on 7/17/17.
//
//

import Foundation

class Post {
    
    fileprivate var _caption: String!
    fileprivate var _imageUrl: String!
    fileprivate var _likes: Int!
    fileprivate var _postKey: String!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        _postKey = postKey
        
        if let caption = postData["caption"] as? String {
            _caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            _imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            _likes = likes
        }
    }
    
}
