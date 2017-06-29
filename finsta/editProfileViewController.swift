//
//  editProfileViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol ModalDelegate {
    func changeProfileImage(value: UIImage)
}

class editProfileViewController: UIViewController, ModalDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!

    @IBOutlet weak var userProfileImageView: PFImageView!
    var userProfileImageFile: PFFile! {
        didSet {
            self.userProfileImageView.file = userProfileImageFile
            self.userProfileImageView.loadInBackground()
        }
    }
    
    var user: PFUser?
    
    @IBAction func userProfileImageTouch(_ sender: Any) {
        performSegue(withIdentifier: "editProfileToChooseProfileImage", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make profile image round
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.clipsToBounds = true
        
        // Set labels to user properties
        if let user = user {
            fullNameTextField.text = (user["fullName"] as? String) ?? ""
            usernameTextField.text = (user["username"] as? String) ?? ""
            bioTextField.text = (user["biography"] as? String) ?? ""
            websiteTextField.text = (user["website"] as? String) ?? ""
            emailTextField.text = (user["email"] as? String) ?? ""
            phoneTextField.text = (user["phone"] as? String) ?? ""
            genderTextField.text = (user["gender"] as? String) ?? ""
            userProfileImageFile = user["profileImage"] as? PFFile
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        // Get information from inputs
        let fullName = fullNameTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let bio = bioTextField.text ?? ""
        let website = websiteTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let gender = genderTextField.text ?? ""
        let profileImage = userProfileImageView.image!
        // Save user information in database
        Post.saveUserInformation(user: user!, username: username, fullName: fullName, bio: bio, website: website, email: email, phone: phone, gender: gender, profileImage: profileImage) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                print("Error saving user information")
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonTouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeProfileImage(value: UIImage) {
        userProfileImageView.image = value
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileToChooseProfileImage" {
            let vc = segue.destination as! chooseProfileImageViewController
            vc.delegate = self
        }
    }

}
