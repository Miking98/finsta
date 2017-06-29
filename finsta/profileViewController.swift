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

class profileViewController: UIViewController {

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
    var userInfo: PFObject?
    
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
        
        Post.getUserInformation(user: user!) { (queryUser: PFObject?, queryError: Error?) in
            if let queryUser = queryUser {
                self.userInfo = queryUser
                // Set labels to user properties
                self.postsLabel.text = (self.userInfo!["postsCount"] as? String) ?? "0"
                self.followersLabel.text = (self.userInfo!["followersCount"] as? String) ?? "0"
                self.followingLabel.text = (self.userInfo!["followingCount"] as? String) ?? "0"
                self.userProfileImageFile = self.userInfo!["profileImage"] as? PFFile
                self.fullNameLabel.text = (self.userInfo!["fullName"] as? String) ?? "Your name"
                self.biographyLabel.text = (self.userInfo!["biography"] as? String) ?? ""
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToEditProfile" {
            let vc = segue.destination as! editProfileViewController
            vc.userInfo = userInfo
        }
    }

}
