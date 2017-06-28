//
//  commentsTableViewCell.swift
//  finsta
//
//  Created by Michael Wornow on 6/27/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class commentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var userProfileImageFile: PFFile! {
        didSet {
            self.userProfileImageView.file = userProfileImageFile
            self.userProfileImageView.loadInBackground()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Wrap comment text around username
        self.layoutIfNeeded()
        let usernameFrame = UIBezierPath(rect: userProfileImageView.frame)
        contentTextView.textContainer.exclusionPaths = [usernameFrame]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

}