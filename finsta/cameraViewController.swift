//
//  cameraViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class cameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var libraryTabButton: UIButton!
    @IBOutlet weak var photoTabButton: UIButton!
    @IBOutlet weak var videoTabButton: UIButton!
    
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    var postImage: UIImage?
    var postImageAsset: PHAsset?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func libraryTabButtonTouch(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func photoTabButtonTouch(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        }
        else {
            print("Camera 🚫 available")
        }
    }
    
    @IBAction func videoTabButtonTouch(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
            vc.mediaTypes = [kUTTypeMovie as String]
            self.present(vc, animated: true, completion: nil)
        }
        else {
            print("Camera 🚫 available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Get image metadata
        let URL = info[UIImagePickerControllerReferenceURL] as! URL
        let opts = PHFetchOptions()
        opts.fetchLimit = 1
        let asset = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)[0]
        let creationDate = asset.creationDate
        let location = asset.location
        
        // Display image and metadata to user
        selectedImageView.image = editedImage
        if creationDate != nil {
            dateCreatedLabel.text = Post.humanReadableDateFromDate(date: creationDate!)
        }
        else {
            dateCreatedLabel.text = "N/A"
        }
        if location != nil {
            locationLabel.text = Post.getGeoLocationFromCoords(location: location!)
        }
        else {
            locationLabel.text = "N/A"
        }
        
        // Save image info to object
        postImage = editedImage
        postImageAsset = asset
        
        // Enable Next button
        nextBarButton.isEnabled = true
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! postImageViewController
        vc.postImage = postImage
        vc.postImageAsset = postImageAsset
    }
    

}
