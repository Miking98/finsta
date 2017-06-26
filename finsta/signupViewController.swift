//
//  signupViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class signupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonTouch(_ sender: Any) {
        let newUser = PFUser()
        let loginViewControllerInstance = loginViewController()
        
        // Set user properties
        newUser.username = usernameTextField.text ?? ""
        newUser.email = emailTextField.text ?? ""
        newUser.password = passwordTextField.text ?? ""
        
        //Error checking
        var error = false
        var alertInfo: [[String: Any]] = []
        usernameTextField.layer.borderWidth = 0
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        if newUser.username!.isEmpty {
            error = true
            let info: [String: Any] = [ "view": self, "fieldName" : "username", "field" : usernameTextField ]
            alertInfo.append(info)
        }
        if newUser.email!.isEmpty || newUser.email!.range(of:"@") == nil {
            error = true
            let info: [String: Any] = [ "view": self, "fieldName" : "email", "field" : emailTextField ]
            alertInfo.append(info)
        }
        if newUser.password!.isEmpty {
            error = true
            let info: [String: Any] = [ "view": self, "fieldName" : "password", "field" : passwordTextField ]
            alertInfo.append(info)
        }
        if !error {
            // Sign user up
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("User Registered successfully")
                    self.performSegue(withIdentifier: "signedUpSegue", sender: nil)
                }
            }
        }
        else {
            loginViewControllerInstance.alertInvalid(info: alertInfo, alertIndex: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

