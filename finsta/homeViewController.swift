//
//  homeViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [PFObject] = []
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup main feed table
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        // Fetch 20 most recent posts
        fetchMostRecentPosts(numberOfPosts: 20)
        
        // Initialize a UIRefreshControl to fetch latest posts
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        feedTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "feedTableViewCell") as! feedTableViewCell
        let post = posts[indexPath.row]
        
        let author = post["author"] as! PFUser
        cell.usernameLabel.text = author.username!
        cell.locationLabel.text = post["location"] as? String
        print(post)
        cell.createdDateLabel.text = Post.humanReadableDateFromDate(date: (post.createdAt as! Date)).uppercased()
        cell.postImageFile = post["media"] as? PFFile
        
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMostRecentPosts(numberOfPosts: 20)
    }
    
    func alertNetworkError() {
        let alertController = UIAlertController(title: "Network Error", message: "Error fetching data from Parse database. Please check your network connection.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Reload page
            self.viewDidLoad()
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true){}
    }
    
    func fetchMostRecentPosts(numberOfPosts: Int) {
        let currentDate = Date()
        Post.getMostRecentPosts(startDate: currentDate, numberOfPosts: numberOfPosts, completion: { (queryPosts: [PFObject]?, queryError: Error?) -> Void in
            if let queryPosts = queryPosts {
                self.posts = queryPosts
                self.feedTableView.reloadData()
            }
            else {
                self.alertNetworkError()
                print(queryError!.localizedDescription)
            }
            if (self.posts.count == 0) {
                print("No posts")
            }
            self.refreshControl.endRefreshing()
        })
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
