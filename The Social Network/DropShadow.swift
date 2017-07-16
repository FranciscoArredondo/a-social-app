//
//  DropShadow.swift
//  The Social Network
//
//  Created by Francisco on 7/15/17.
//
//

import UIKit

protocol DropShadow {}

extension DropShadow where Self: UIView {
    func addDropShadow() {
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
