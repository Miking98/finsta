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
    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    
    var post: PFObject?
    var comments: [PFObject] = []
    let NUMBER_OF_COMMENTS_FETCH_AT_ONCE = 20
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var feedIsLoadingMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        
        // Setup main feed table
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
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
        
        // Style add comments text field
        addCommentTextField.placeholder = String(format: "Add a comment as %@", user.username!)
        // Get post information
        if let post = post {
            // Fetch 20 oldest comments
            fetchComments(startNumber: 0, numberOfComments: NUMBER_OF_COMMENTS_FETCH_AT_ONCE, post: post, completion: { (error: Error?) -> Void in
            })
        }
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
        cell.dateCreatedLabel.text = Post.instagramStyleDateFromDate(date: (comment.createdAt!)).uppercased()
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
        fetchComments(startNumber: 0, numberOfComments: NUMBER_OF_COMMENTS_FETCH_AT_ONCE, post: post!, completion: { (error: Error?) -> Void in
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
    
    func fetchComments(startNumber: Int, numberOfComments: Int, append: Bool = false, post: PFObject, completion: @escaping (_ error: Error?) -> Void) {
        Post.getOldestComments(startNumber: startNumber, numberOfComments: numberOfComments, post: post) { (queryComments: [PFObject]?, queryError: Error?) in
            if let queryComments = queryComments {
                if append {
                    for q in queryComments {
                        self.comments.append(q)
                    }
                }
                else {
                    self.comments = queryComments
                }
                self.commentsTableView.reloadData()
            }
            else {
                self.alertNetworkError()
                print(queryError!.localizedDescription)
            }
            if (self.comments.count == 0) {
                print("No comments")
            }
            completion(queryError)
        }
    }
    
    @IBAction func addCommentEditingChanged(_ sender: Any) {
        // Enable Post button when user enters text into comment field
        if addCommentTextField.text != "" {
            postCommentButton.isEnabled = true
        }
        else {
            postCommentButton.isEnabled = false
        }
    }
    
    @IBAction func postButtonTouch(_ sender: Any) {
        let user = PFUser.current()
        let content = addCommentTextField.text ?? ""
        // Disable text field
        addCommentTextField.isUserInteractionEnabled = false
        
        Post.createCommentOnPost(user: user!, post: post!, content: content) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                print("Error creating comment")
            }
            else {
                self.addCommentTextField.text = ""
                self.postCommentButton.isEnabled = false
            }
            self.addCommentTextField.isUserInteractionEnabled = true
        }
        // Reload comments
        self.viewDidLoad()
    }
    
    @IBAction func userProfileImageTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "commentsToProfile", sender: sender)
    }
    @IBAction func usernameTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "commentsToProfile", sender: sender)
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
