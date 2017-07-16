//
//  SignInVC.swift
//  The Social Network
//
//  Created by Francisco on 7/14/17.
//
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!

    @IBOutlet weak var fbLoginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addDropShadow()
        fbLoginButton.asCircle()
        signInButton.configureSignInButton()
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
    }
}

