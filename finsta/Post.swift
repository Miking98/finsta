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
        post.saveInBackground { (success: Bool, error: Error?) in
            if success {
                comment.saveInBackground(block: completion)
            }
            else {
                if completion != nil {
                    completion!(success, error)
                }
            }
        }
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
        
        query.findObjectsInBackground { (queryPosts: [PFObject]?, queryError: Error?) in
            if let queryPosts = queryPosts {
                postObjs = queryPosts
            }
            else {
                print(queryError!.localizedDescription)
                postError = queryError
                postObjs = nil
            }
            completion(postObjs, postError)
        }
        
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
