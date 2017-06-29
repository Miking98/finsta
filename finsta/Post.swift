//
//  Post.swift
//  finsta
//
//  Created by Michael Wornow on 6/26/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import Parse

class Post: AnyObject {
    
    class func postUserImage(image: UIImage?, caption: String?, date: Date?, location: CLLocation?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        post["media"] = getPFFileFromImage(image: image) // PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["dateCreated"] = date // Date photo was taken
        post["location"] = location != nil ? Post.getGeoLocationFromCoords(location: location!) : nil
        post["likesCount"] = 0
        
        // Save caption as first comment
        let comment = PFObject(className: "Comment")
        comment["author"] = PFUser.current()
        comment["content"] = caption
        comment["likesCount"] = 0
        comment["post"] = post
        
        // Save post and caption (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                comment.saveInBackground(block: completion)
            }
            else {
                if completion != nil {
                    completion!(success, error)
                }
            }
        })
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    // Get *numberOfPosts* most recent posts that were created before *startDate*
    class func getMostRecentPosts(startDate: Date, numberOfPosts: Int, completion: @escaping (_ posts: [PFObject]?, _ error: Error?) -> Void) {
        let predicate = NSPredicate(format: "createdAt < %@", startDate as NSDate)
        let query = PFQuery(className: "Post", predicate: predicate)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = numberOfPosts
        
        var postObjs: [PFObject]? = []
        var postError: Error? = nil
        
        query.findObjectsInBackground(block: { (queryPosts: [PFObject]?, queryError: Error?) in
            if let queryPosts = queryPosts {
                postObjs = queryPosts
            }
            else {
                print(queryError!.localizedDescription)
                postError = queryError
                postObjs = nil
            }
            completion(postObjs, postError)
        })
        
    }
    
    // Get *numberOfComments* oldest comments starting with comment number *startNumber*
    class func getOldestComments(startNumber: Int, numberOfComments: Int, post: PFObject, completion: @escaping (_ posts: [PFObject]?, _ error: Error?) -> Void) {
        let predicate = NSPredicate(format: "post = %@", post)
        let query = PFQuery(className: "Comment", predicate: predicate)
        query.order(byAscending: "createdAt")
        query.includeKey("author")
        query.skip = startNumber
        query.limit = numberOfComments
        
        var commentObjs: [PFObject]? = []
        var commentError: Error? = nil
        
        query.findObjectsInBackground(block: { (queryComments: [PFObject]?, queryError: Error?) in
            if let queryComments = queryComments {
                commentObjs = queryComments
            }
            else {
                print(queryError!.localizedDescription)
                commentError = queryError
                commentObjs = nil
            }
            completion(commentObjs, commentError)
        })
        
    }
    
    // Get information (name, followers, posts, etc.) for user *user*
    class func getUserInformation(user: PFUser, completion: @escaping (_ user: PFUser?, _ error: Error?) -> Void) {
        let query = PFUser.query()!
        query.whereKey("username", equalTo: user.username!)
        query.limit = 1
        
        var userObj: PFUser?
        var userError: Error? = nil
        
        query.findObjectsInBackground(block: { (queryUsers: [PFObject]?, queryError: Error?) in
            if let queryUsers = queryUsers {
                if queryUsers.count == 1 {
                    userObj = queryUsers[0] as? PFUser
                }
                else {
                    print("No users matched")
                }
            }
            else {
                print(queryError!.localizedDescription)
                userError = queryError
                userObj = nil
            }
            completion(userObj, userError)
        })
        
    }
    
    // Save information in database for user *user*
    class func saveUserInformation(user: PFUser, username: String, fullName: String, bio: String, website: String, email: String, phone: String, gender: String, profileImage: UIImage, completion: @escaping (_ error: Error?) -> Void) {
        user["username"] = username
        user["fullName"] = fullName
        user["biography"] = bio
        user["website"] = website
        user["email"] = email
        user["phone"] = phone
        user["gender"] = gender
        user["profileImage"] = getPFFileFromImage(image: profileImage)
        
        user.saveInBackground(block: { (success: Bool, error: Error?) in
            completion(error)
        })
    }
    
    class func updatePostLikes(post: PFObject, delta: Int, completion: @escaping (_ error: Error?) -> Void) {
        post["likesCount"] = (post["likesCount"] as! Int) + delta
        post.saveInBackground(block: { (success: Bool, error: Error?) in
            completion(error)
        })
    }
    
    class func humanReadableDateFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return String(format: "%@ at %@", dateFormatter.string(from: date), timeFormatter.string(from: date))
    }
    
    class func instagramStyleDateFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return String(format: "%@", dateFormatter.string(from: date))
    }
    
    class func getGeoLocationFromCoords(location: CLLocation) -> String {
        var geoLocation = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {
                if let placemark = placemarks.first {
                    if placemark.locality != nil {
                        geoLocation += placemark.locality!
                    }
                    if placemark.administrativeArea != nil {
                        geoLocation += " " + placemark.administrativeArea!
                        
                    }
                }
            }
        }
        return geoLocation
    }
}
