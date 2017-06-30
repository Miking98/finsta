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

class profileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, EditProfileModalDelegate {

    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var userProfileImageView: PFImageView!
    var userProfileImageFile: PFFile! {
        didSet {
            self.userProfileImageView.file = userProfileImageFile
            self.userProfileImageView.loadInBackground()
        }
    }
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var postsCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var user: PFUser?
    var userPosts: [PFObject] = []
    var NUMBER_OF_POSTS_FETCH_AT_ONCE = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup collection view
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionViewFlowLayout.minimumLineSpacing = 0
        postsCollectionViewFlowLayout.minimumInteritemSpacing = 0
        
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
        
        // Get user information
        Post.getUserInformation(user: user!) { (queryUser: PFUser?, queryError: Error?) in
            if let queryUser = queryUser {
                self.user = queryUser
                self.setLabels()
                // Get user's posts
                self.fetchUserPosts()
            }
            else {
                print(queryError?.localizedDescription ?? "")
                print("Error getting user information")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setLabels() {
        // Set labels to user properties
        self.postsLabel.text = String(format: "%d", self.user!["postsCount"] as? Int32 ?? 0)
        self.followersLabel.text = String(format: "%d", self.user!["followersCount"] as? Int32 ?? 0)
        self.followingLabel.text = String(format: "%d", self.user!["followingCount"] as? Int32 ?? 0)
        self.userProfileImageFile = self.user!["profileImage"] as? PFFile
        self.fullNameLabel.text = (self.user!["fullName"] as? String) ?? "Your name"
        self.biographyLabel.text = (self.user!["biography"] as? String) ?? ""
        self.websiteLabel.text = (self.user!["website"] as? String) ?? ""
    }
    
    func fetchUserPosts(append: Bool = false) {
        let startDate = Date()
        Post.getUserMostRecentPosts(startDate: startDate, numberOfPosts: self.NUMBER_OF_POSTS_FETCH_AT_ONCE, user: self.user!, completion: { (queryPosts: [PFObject]?, queryError: Error?) in
            if let queryPosts = queryPosts {
                self.userPosts = queryPosts
                self.postsCollectionView.reloadData()
            }
            else {
                print(queryError?.localizedDescription ?? "")
                print("Error fetching user's posts")
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToEditProfile" {
            let vc = segue.destination as! editProfileViewController
            vc.delegate = self
            vc.user = user
        }
        else if segue.identifier == "profileToPostDetail" {
            let cell = sender as! profilePostCollectionViewCell
            let indexPath = postsCollectionView.indexPath(for: cell)!
            let post = userPosts[indexPath.row]
            let vc = segue.destination as! homeViewController
            vc.specificPost = post
        }
        
    }
    
    func updateUserInformation() {
        setLabels()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostCollectionViewCell", for: indexPath) as! profilePostCollectionViewCell
        let post = userPosts[indexPath.row]
        cell.postImageFile = post["media"] as? PFFile
        
        return cell
    }

}
