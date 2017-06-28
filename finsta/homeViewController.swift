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

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [PFObject] = []
    let NUMBER_OF_POSTS_FETCH_AT_ONCE = 1
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var feedIsLoadingMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup main feed table
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        // Fetch 20 most recent posts
        fetchPosts(startDate: Date(), numberOfPosts: NUMBER_OF_POSTS_FETCH_AT_ONCE, completion: { (error: Error?) -> Void in
        })
        
        // Attach UIRefreshControl to feedTableView
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        feedTableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: feedTableView.contentSize.height, width: feedTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        feedTableView.addSubview(loadingMoreView!)
        var insets = feedTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        feedTableView.contentInset = insets
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
        cell.createdDateLabel.text = Post.humanReadableDateFromDate(date: (post.createdAt!)).uppercased()
        cell.postImageFile = post["media"] as? PFFile
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!feedIsLoadingMoreData) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = feedTableView.contentSize.height // Total height of table with all elements filled in (off screen too)
            let scrollOffsetThreshold = scrollViewContentHeight - feedTableView.bounds.size.height // Bounds is height of table currently on screen
                
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && feedTableView.isDragging) { // ContentOffset is how far user has scrolled the table view
                feedIsLoadingMoreData = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: feedTableView.contentSize.height, width: feedTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                //Fetch next posts
                let mostAncientPostAlreadyFetchedDate = posts[posts.count-1].createdAt!
                fetchPosts(startDate: mostAncientPostAlreadyFetchedDate, numberOfPosts: NUMBER_OF_POSTS_FETCH_AT_ONCE, append: true, completion: { (error: Error?) -> Void in
                    self.feedIsLoadingMoreData = false
                    self.loadingMoreView!.stopAnimating()
                })
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPosts(startDate: Date(), numberOfPosts: NUMBER_OF_POSTS_FETCH_AT_ONCE, completion: { (error: Error?) -> Void in
            self.refreshControl.endRefreshing()
        })
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
    
    func fetchPosts(startDate: Date, numberOfPosts: Int, append: Bool = false, completion: @escaping (_ error: Error?) -> Void) {
        Post.getMostRecentPosts(startDate: startDate, numberOfPosts: numberOfPosts, completion: { (queryPosts: [PFObject]?, queryError: Error?) -> Void in
            if let queryPosts = queryPosts {
                if append {
                    for q in queryPosts {
                        self.posts.append(q)
                    }
                }
                else {
                    self.posts = queryPosts
                }
                self.feedTableView.reloadData()
            }
            else {
                self.alertNetworkError()
                print(queryError!.localizedDescription)
            }
            if (self.posts.count == 0) {
                print("No posts")
            }
            completion(queryError)
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
