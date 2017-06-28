//
//  homeViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup main feed table
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        // Fetch 20 most recent posts
        let currentDate = Date()
        Post.getMostRecentPosts(startDate: currentDate, numberOfPosts: 20, completion: { (queryPosts: [PFObject]?, queryError: Error?) -> Void in
            if let queryPosts = queryPosts {
                self.posts = queryPosts
            }
            else {
                print("No posts")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "feedTableView") as! feedTableViewCell
        let post = posts[indexPath.row]
        
        cell.usernameLabel.text = post["title"] as! String
        cell.locationLabel.text = post["location"] as! String
        cell.imageImageView.image = post["image"] as! UIImage
//        if baseImageURL != "" {
//            let fullImageURL = URL(string: baseImageURL + "w500" + imageURL)!
//            let fullImageRequest = URLRequest(url: fullImageURL)
//            cell.photoImageView.af_setImage(withURLRequest: fullImageRequest, placeholderImage: #imageLiteral(resourceName: "movie_poster_placeholder"), imageTransition: .crossDissolve(0.8), runImageTransitionIfCached: false)
//        }
        
        return cell
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
