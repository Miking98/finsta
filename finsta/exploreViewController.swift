//
//  exploreViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/30/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class exploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    @IBOutlet weak var exploreCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var posts: [PFObject] = []
    let NUMBER_OF_POSTS_FETCH_AT_ONCE = 20
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var feedIsLoadingMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up collection view
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        exploreCollectionViewFlowLayout.minimumLineSpacing = 0
        exploreCollectionViewFlowLayout.minimumInteritemSpacing = 0
        
        // Fetch 20 most recent posts
        fetchPosts(startDate: Date(), numberOfPosts: NUMBER_OF_POSTS_FETCH_AT_ONCE, completion: { (error: Error?) -> Void in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreToPostDetail" {
            let cell = sender as! exploreCollectionViewCell
            let indexPath = exploreCollectionView.indexPath(for: cell)!
            let post = posts[indexPath.row]
            let vc = segue.destination as! homeViewController
            vc.specificPost = post
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCollectionViewCell", for: indexPath) as! exploreCollectionViewCell
        let post = posts[indexPath.row]
        cell.postImageFile = post["media"] as? PFFile
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Infinite scroll for home feed, not for post detail view
        if (!feedIsLoadingMoreData) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = exploreCollectionView.contentSize.height // Total height of table with all elements filled in (off screen too)
            let scrollOffsetThreshold = scrollViewContentHeight - exploreCollectionView.bounds.size.height // Bounds is height of table currently on screen
            
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && exploreCollectionView.isDragging && posts.count > 0) { // ContentOffset is how far user has scrolled the table view
                feedIsLoadingMoreData = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: exploreCollectionView.contentSize.height, width: exploreCollectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
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
                self.exploreCollectionView.reloadData()
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

}
