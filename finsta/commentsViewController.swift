//
//  commentsViewController.swift
//  finsta
//
//  Created by Michael Wornow on 6/28/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class commentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments: [PFObject] = []
    let NUMBER_OF_COMMENTS_FETCH_AT_ONCE = 1
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var feedIsLoadingMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup main feed table
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        // Fetch 20 most recent comments
        fetchComments(startNumber: 0, numberOfComments: NUMBER_OF_COMMENTS_FETCH_AT_ONCE, completion: { (error: Error?) -> Void in
        })
        
        // Attach UIRefreshControl to commentsTableView
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        commentsTableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: commentsTableView.contentSize.height, width: commentsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        commentsTableView.addSubview(loadingMoreView!)
        var insets = commentsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        commentsTableView.contentInset = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentsTableViewCell") as! commentsTableViewCell
        let comment = comments[indexPath.row]
        
        let author = comment["author"] as! PFUser
        cell.usernameLabel.text = author.username!
        cell.contentTextView.text = comment["content"] as? String
        //cell.createdDateLabel.text = Post.instagramStyleDateFromDate(date: (comment.createdAt!)).uppercased()
        cell.userProfileImageFile = author["profileImage"] as? PFFile
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!feedIsLoadingMoreData) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = commentsTableView.contentSize.height // Total height of table with all elements filled in (off screen too)
            let scrollOffsetThreshold = scrollViewContentHeight - commentsTableView.bounds.size.height // Bounds is height of table currently on screen
            
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && commentsTableView.isDragging && comments.count > 0) { // ContentOffset is how far user has scrolled the table view
                feedIsLoadingMoreData = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: commentsTableView.contentSize.height, width: commentsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                //Fetch next posts
                self.feedIsLoadingMoreData = false
                self.loadingMoreView!.stopAnimating()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchComments(startNumber: 0, numberOfComments: NUMBER_OF_COMMENTS_FETCH_AT_ONCE, completion: { (error: Error?) -> Void in
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
    
    func fetchComments(startNumber: Int, numberOfComments: Int, append: Bool = false, completion: @escaping (_ error: Error?) -> Void) {
        
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
