//
//  chooseProfileImageViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit

class chooseProfileImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate: ModalDelegate?
    var postImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        if postImage != nil {
            if let delegate = self.delegate {
                delegate.changeProfileImage(value: postImage!)
            }
            dismiss(animated: true, completion: nil)
        }
        else {
            print("Error, no image selected")
        }
    }
    
    @IBAction func cancelButtonTouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func libraryButtonTouch(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func photoButtonTouch(_ sender: UIButton) {
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
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Save image info to object
        postImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

}
