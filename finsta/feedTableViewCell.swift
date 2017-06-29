//
//  feedTableViewCell.swift
//  finsta
//
//  Created by Michael Wornow on 6/27/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class feedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imagePFView: PFImageView!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bookmarkButtonImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var topCommentUsernameLabel: UILabel!
    @IBOutlet weak var topCommentContentLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    var postImageFile: PFFile! {
        didSet {
            self.imagePFView.file = postImageFile
            self.imagePFView.loadInBackground()
        }
    }
    
    var delegate: feedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make profile image round
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    @IBAction func heartButtonTouch(_ sender: Any) {
        var delta = 0
        if heartButton.imageView!.image == #imageLiteral(resourceName: "heart") {
            print("HI")
            heartButton.setImage(#imageLiteral(resourceName: "fullheart"), for: UIControlState.normal)
            delta = 1
        }
        else {
            heartButton.setImage(#imageLiteral(resourceName: "heart"), for: UIControlState.normal)
            delta = -1
        }
        self.delegate!.likePostToggle(cell: self, delta: delta)
    }

}
