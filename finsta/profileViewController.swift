//
//  profileViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {

    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Style "Edit Profile" and "Settings" button
        editProfileButton.layer.cornerRadius = 2;
        editProfileButton.layer.borderWidth = 1;
        editProfileButton.layer.borderColor = UIColor.gray.cgColor
        settingsButton.layer.cornerRadius = 2;
        settingsButton.layer.borderWidth = 1;
        settingsButton.layer.borderColor = UIColor.gray.cgColor
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
