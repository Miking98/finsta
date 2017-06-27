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

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var postImage: UIImage?
    var postImageAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let postImage = postImage {
            imageView.image = postImage
            
            
            let caption = "asdf"
            
            // Do something with the images (based on your use case)
            Post.postUserImage(image: postImage, withCaption: caption) { (status: Bool, error: Error?) in
            }
        }
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
