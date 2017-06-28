//
//  settingsViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class settingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutTouch(_ sender: UIButton) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.alertLogOutError()
            }
            else {
                // Log out successful
                // Send user back to sign up page
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "signupController") as! signupViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func alertLogOutError() {
        let alertController = UIAlertController(title: "Logout Error", message: "Error logging you out. Please try again.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Reload page
            self.viewDidLoad()
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true){}
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
