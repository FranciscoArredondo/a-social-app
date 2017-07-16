//
//  SignInVC.swift
//  The Social Network
//
//  Created by Francisco on 7/14/17.
//
//

import UIKit
import FacebookLogin
import FirebaseAuth

class SignInVC: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!

    @IBOutlet weak var fbLoginButton: UIButton!
    
    @IBOutlet weak var emailTextField: SignInUITextField!
    
    @IBOutlet weak var passwordTextField: SignInUITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        headerView.addDropShadow()
        fbLoginButton.asCircle()
        signInButton.configureSignInButton()
        
    }

    @IBAction func facebookLoginBtnPress(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("PF: There was an error with facebook authentication: \(error)")
            case .cancelled:
                print("PF: User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("PF: Logged in!")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("PF: Unable to sign in with firebase")
            } else {
                print("PF: Sucessful sign in with firebase")
            }
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("PF: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("PF: Email user could not be created on Firebase, error: \(String(describing: error))")
                        } else {
                            print("PF: Sucessfully created/authenticated new user on Firebase")
                        }
                    })
                }
            })
        }
    }
}

