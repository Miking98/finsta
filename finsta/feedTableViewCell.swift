//
//  feedTableViewCell.swift
//  finsta
//
//  Created by Michael Wornow on 6/27/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit

class feedTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
