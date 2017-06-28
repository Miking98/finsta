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
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imagePFView: PFImageView!
    
    
    @IBOutlet weak var heartButtonImageView: UIImageView!
    @IBOutlet weak var commentButtonImageView: UIImageView!
    @IBOutlet weak var sendButtonImageView: UIImageView!
    @IBOutlet weak var bookmarkButtonImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var topCommentUsernameLabel: UILabel!
    @IBOutlet weak var topCommentContentLabel: UILabel!
    @IBOutlet weak var viewCommentsLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    var postImageFile: PFFile! {
        didSet {
            self.imagePFView.file = postImageFile
            self.imagePFView.loadInBackground()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

}
