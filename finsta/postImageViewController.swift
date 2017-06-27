//
//  postImageViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/27/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import Photos

class postImageViewController: UIViewController {

    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    
    var postImage: UIImage?
    var postImageAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let postImage = postImage {
            imageView.image = postImage
            if let postImageAsset = postImageAsset {
                dateCreatedLabel.text = Post.humanReadableDateFromDate(date: postImageAsset.creationDate!)
                locationLabel.text = Post.getGeoLocationFromCoords(location: postImageAsset.location!)
            }
            else {
                dateCreatedLabel.text = "N/A"
                locationLabel.text = "N/A"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTouch(_ sender: UIButton) {
        let caption = captionTextView.text ?? ""
        
        Post.postUserImage(image: postImage, withCaption: caption) { (status: Bool, error: Error?) in
        }
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
