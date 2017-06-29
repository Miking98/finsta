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
    
    var userInfo: PFObject?
    
    @IBAction func userProfileImageTap(_ sender: UITapGestureRecognizer) {
        // Modally present up profile image chooser
        performSegue(withIdentifier: "editProfileToChooseProfileImage", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make profile image round
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.clipsToBounds = true
        
        if let userInfo = userInfo {
            // Set labels to user properties
            self.userProfileImageFile = userInfo["profileImage"] as? PFFile
            self.fullNameTextField.text = (userInfo["fullName"] as? String) ?? ""
            self.bioTextField.text = (userInfo["biography"] as? String) ?? ""
            self.websiteTextField.text = (userInfo["website"] as? String) ?? ""
            self.emailTextField.text = (userInfo["email"] as? String) ?? ""
            self.phoneTextField.text = (userInfo["phone"] as? String) ?? ""
            self.genderTextField.text = (userInfo["gender"] as? String) ?? ""
        }
        
        let chooseImageVC = chooseProfileImageViewController()
        chooseImageVC.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        // Save user information in database
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeProfileImage(value: UIImage) {
        userProfileImageFile = Post.getPFFileFromImage(image: value)
    }

}
