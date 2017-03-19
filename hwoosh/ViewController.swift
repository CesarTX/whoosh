//
//  ViewController.swift
//  hwoosh
//
//  Created by Cesar Tejada on 3/7/17.
//  Copyright © 2017 hwoosh. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore


class ViewController: UIViewController
{
    //@IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var customLoginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //MARK: Private Variables
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    @IBAction func LoginWithFacebookAction(_ sender: Any)
    {
        activityIndicator.startAnimating()
        customLoginButton.isEnabled = false
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile,.email ], viewController: self)
        { loginResult in
            switch loginResult
            {
            case .failed(let error):
                print(error)
                self.activityIndicator.stopAnimating()
            case .cancelled:
                print("User cancelled login.")
                self.activityIndicator.stopAnimating()
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken:accessToken.authenticationToken)
                    
                FIRAuth.auth()?.signIn(with: credential)
                { (user, error) in
                        // ...
                        if let error = error {
                            // ...
                            print("There was an error!")
                            self.activityIndicator.stopAnimating()
                            print(error)
                        }
                    else
                        {
                    
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ListOfActivities") as! ListOfActivities
                
                            self.present(VC, animated: true, completion: {self.activityIndicator.stopAnimating()})

                            print("Logged in!")
                    }
                }

            }
            self.customLoginButton.isEnabled = true
        }
    }
    
    
    override func viewDidLoad()
    {
        //loginButton.delegate = self
        customLoginButton.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        customLoginButton.layer.cornerRadius = 8
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}

