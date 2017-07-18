//
//  DataService.swift
//  The Social Network
//
//  Created by Francisco on 7/17/17.
//
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()


class DataService {
    
    static let ds = DataService()
    
    fileprivate var _REF_BASE = DB_BASE
    fileprivate var _REF_POSTS = DB_BASE.child("posts")
    fileprivate var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
