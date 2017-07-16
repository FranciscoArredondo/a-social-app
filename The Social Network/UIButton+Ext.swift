//
//  UIButton+Ext.swift
//  The Social Network
//
//  Created by Francisco on 7/15/17.
//
//

import UIKit

extension UIButton {
    func asCircle() {
        layer.cornerRadius = layer.bounds.height/2
        clipsToBounds = true
    }
    
    func configureSignInButton() {
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }
}
