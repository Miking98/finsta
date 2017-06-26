//
//  loginViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Error highlights
    let errorHighlight : UIColor = UIColor.red
    
    @IBAction func loginButtonTouch(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //Error checking
        var error = false
        var alertInfo: [[String: Any]] = []
        usernameTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        if username.isEmpty {
            error = true
            let info: [String: Any] = [ "view": self, "fieldName" : "username", "field" : usernameTextField ]
            alertInfo.append(info)
        }
        if password.isEmpty {
            error = true
            let info: [String: Any] = [ "view": self, "fieldName" : "password", "field" : passwordTextField ]
            alertInfo.append(info)
        }
        if !error {
            loginUser(username: username, password: password)
        }
        else {
            alertInvalid(info: alertInfo, alertIndex: 0)
        }
    }
    
    func loginUser(username: String, password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            }
        }
    }
    
    func alertInvalid(info: [[String: Any]], alertIndex: Int) {
        let view = info[alertIndex]["view"] as! UIViewController
        let fieldName = info[alertIndex]["fieldName"] as! String
        let field = info[alertIndex]["field"] as! UITextField
        
        // Alert
        let alertController = UIAlertController(title: "Invalid "+fieldName, message: "Please enter a valid "+fieldName, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // Show next alert
            let nextAlertIndex = alertIndex + 1
            if nextAlertIndex < info.count {
                self.alertInvalid(info: info, alertIndex: nextAlertIndex)
            }
        }
        alertController.addAction(cancelAction)
        view.present(alertController, animated: true) {}
        
        // Textfield highlight
        field.layer.borderWidth = 1
        field.layer.borderColor = errorHighlight.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
