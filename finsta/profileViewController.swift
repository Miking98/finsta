//
//  profileViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol EditProfileModalDelegate {
    func updateUserInformation()
}

class profileViewController: UIViewController, EditProfileModalDelegate {

    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var userProfileImageView: PFImageView!
    var userProfileImageFile: PFFile! {
        didSet {
            self.userProfileImageView.file = userProfileImageFile
            self.userProfileImageView.loadInBackground()
        }
    }
    
    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make profile image round
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.clipsToBounds = true

        // Style "Edit Profile" and "Settings" button
        editProfileButton.layer.cornerRadius = 2;
        editProfileButton.layer.borderWidth = 1;
        editProfileButton.layer.borderColor = UIColor.gray.cgColor
        settingsButton.layer.cornerRadius = 2;
        settingsButton.layer.borderWidth = 1;
        settingsButton.layer.borderColor = UIColor.gray.cgColor
        
        // Get current user
        user = PFUser.current()
        
        Post.getUserInformation(user: user!) { (queryUser: PFUser?, queryError: Error?) in
            if let queryUser = queryUser {
                self.user = queryUser
                self.setLabels()
            }
        }
        
    }

    func setLabels() {
        // Set labels to user properties
        self.postsLabel.text = (self.user!["postsCount"] as? String) ?? "0"
        self.followersLabel.text = (self.user!["followersCount"] as? String) ?? "0"
        self.followingLabel.text = (self.user!["followingCount"] as? String) ?? "0"
        self.userProfileImageFile = self.user!["profileImage"] as? PFFile
        self.fullNameLabel.text = (self.user!["fullName"] as? String) ?? "Your name"
        self.biographyLabel.text = (self.user!["biography"] as? String) ?? ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToEditProfile" {
            let vc = segue.destination as! editProfileViewController
            vc.delegate = self
            vc.user = user
        }
    }
    
    func updateUserInformation() {
        setLabels()
    }

}
