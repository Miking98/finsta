//
//  exploreCollectionViewCell.swift
//  finsta
//
//  Created by Michael Wornow on 6/30/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class exploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    var postImageFile: PFFile! {
        didSet {
            self.postImageView.file = postImageFile
            self.postImageView.loadInBackground()
        }
    }
}
